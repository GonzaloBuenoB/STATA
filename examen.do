cd "D:\exastata"

*II. TABLA
use enaho01a-2016-300 , clear
merge m:1 conglome vivienda hogar using sumaria-2016, nogen

codebook inghog2d p208a p300a

*Al menos 1 amerindia
*Como se desea tener el valor máximo, se cuentan a los missings como que cumplen
gen amerindia=inlist(p300a,1,2,3,.)
gen edad=p208<18
gen aux=edad+amerindia==2

bys conglome vivienda hogar: egen cumple=max(aux)
replace cumple=. if codperso!="01"

xtile decil=inghog2d [pw=factor07] if cumple !=. , nq(10) 
table decil [pw=factor07], c(mean cumple)

/*
------------------------
10        |
quantiles |
of        |
inghog2d  | mean(cumple)
----------+-------------
       10 |     .2197916
------------------------
*/

*III Gráfico
*Arreglar bases
/*
use enaho01a-2004-300.dta, clear
replace conglome="00" + conglome
save "enaho01a-2004-300.dta", replace

use enaho01a-2016-300.dta, clear
gen anio=2016
save enaho01a-2016-300.dta, replace

use enaho01a-2016-500.dta, clear
destring anio, replace
save enaho01a-2016-500.dta, replace
*/

*1
use enaho01a-2004-500.dta, clear
merge 1:1 anio conglome vivienda hogar codperso using enaho01a-2004-300.dta
save "2004.dta", replace

use enaho01a-2016-500.dta, clear
merge 1:1 anio conglome vivienda hogar codperso using enaho01a-2016-300.dta
save "2016.dta", replace

use 2004.dta, clear
append using 2016.dta
save enaho.dta, replace

*2
use enaho_ayuda.dta, clear
egen sal_pri=rowtotal(d529-i524), m
replace sal_pri=sal_pri/12

gen lengua=inrange(p300a,1,3) if p300a!=. | inrange(p300a,8,.)
label def len 1 amerindia 0 indoeuropea
label values lengua len

egen grupo=group(p207 lengua)
label def gru 1 "hombre - indoeuropeo" 2 "hombre - amerindio" 3 "mujer - indoeuropea" 4 "mujer - amerindia"
label values grupo gru

foreach a of numlist 2004 2016{
foreach s of numlist 1/4{
xtile centil_`a'_`s'=sal_pri [pw=fac500a] if anio==`a' & grupo==`s'  , nq(100)
}
}
egen centil=rowtotal(centil_*), m
drop centil_*

*3
use enaho_ayuda2.dta, clear

hist sal_pri if inrange(centil,1,80) [fw=round(fac500a)], by(grupo anio, c(2) title("Distribución del salario según sexo y lengua materna")) xline(460) xline(850) xtitle("") w(150) ytitle("") ylabel(,angle(horizontal))



