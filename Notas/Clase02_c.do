cd "D:\STATA GG"
use datos1, clear


*COMANDOS PARA EXPLORAR

bro
describe //no requiere cargar base de datos previamente
lookfor ingreso
lookfor "caracol"
count //if bys
bys sector: count if sexo==1
ret list

*borrar variables sobre ocupación secundaria"
lookfor secundaria
drop *2 //ocup_sec
*quedarme solo con las mujeres
keep if sexo==1
*NO SE PUEDE BORRAR COLUMNAS Y FILAS A LA VEZ
*drop *2 if sexo==0

bro sector ingxh* if ocup_sec==1
bro ,nolabel

gsort sector -ingxh
bro sector ingxh

list
list ocup_sec ingxh if edad>60

*EXPLORAR Y VALIDAR VARIABLES

codebook id
codebook dominio
codebook ingxh
codebook dpto //no guarda valores
tab dpto //varname no varlist
sum ingxh //usar para guardar variables

inspect edad
compare ing1 ing

use datos1, clear
compare ing1 ing2 
list ing1 ing2 if ing1<ing2 & ing2!=.

*CREAR VARIABLES
gen hola1=100
gen hola2="hola"
gen hola3=(sexo==1)

set type double,perm //automaticamente usa double

gen str4 ejem1=""
gen byte ejem2=.
gen float ejem3=ln(ingxh1)
gen ejem4=ln(ingxh1)
gen ejem5=(horas1>40)
gen ejem9=(ingxh2>10) // missing: . es infinito
sort ingxh2
bro ingxh2 ejem9

replace ejem1="holas"
replace ejem2=rnormal()
rename ejem5 ejem6
drop ejem* hola*

*EJEM 3
use datos1, clear
gen ejem1=ln(ingxh1) in 1/25
gen ejem2=((dominio<4 | dominio==8) & sexo==1) //comodines solo en varlist
			*inlist(dominio,1,2,3,8)
gen ejem3=ln(ingxh2) if sexo==1 & (dominio<8 & dominio>3)
									*inlist(dominio,4,5,6,7)
									*inrange(dominio4,7) //sí incluye 7 [4,7]
									*inrange(ingxh,10,.) //sin incluir missing [10.3[
gen ejem4=(ingxh2>5) if sexo==1 & inrange(dominio,4,7)
gen ejem4_azul=(ingxh2>5) if sexo==1 & inrange(dominio,4,7)
gen ejem4_verde=(ingxh2>5) if sexo==1 & inrange(dominio,4,7)

drop ejem*

gen ejem1=_n //@trend
gen ejem2=_N

bro horas*
gen horas_sem=horas1+horas2
*problema #+.=.
drop horas_sem
egen horas_sem=rowtotal(horas1 horas2)
*solución #+.=#
*problema .+.=0
*egen horas_sem=rowtotal(horas1 horas2), m

*help function <- funciones de gen (solo para gen y
							*otras partes de la sintaxis)
*help egen <- funciones de egen (solo para egen)

bro sexo sector
sort sexo sector
egen muj_sec=group(sexo sector)

bys muj_sec: gen nobs_ms=_N
bys muj_sec: gen id_ms=_n
bro

bro sexo sector horas_sem
bys muj_sec: egen horas_tot_ms=total(horas_sem)

sort horas_sem
gen horas_acu=sum(horas_sem)

sort muj_sec horas_sem
bys muj_sec:gen horas_acu_ms=sum(horas_sem)

des

*ETIQUETAS DE VARIABLES

gen region= ///
inlist(dominio,1,2,3,8)*1 + ///
inrange(dominio,4,6)*2 + ///
(dominio==7)*3

label variable region "Región Natural"
label define caracol 1 "Costa" 2 "Sierra" 3 "Selva"
label values region caracol
desc
codebook region
label list dominio

bro dominio
decode dominio, gen(oruga) //varname gen obligatorio

bro dpto
encode dpto, gen(babosa)
codebook babosa
label list babosa

sort edad
bro edad gedad

recode edad (min/18=1 "<18a") (19/25=2 "19-25") (26/55=3 "26-55") (56/max=4 ">55a"), gen(caracol)
