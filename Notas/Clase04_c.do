cd "D:\STATA GG"
use datos1, clear

*BUCLES CERRADOS

forvalues guau=9(4)20{
*replace prro=rnormal()
gen prro`guau'=rnormal()
}

forvalues guau=20/23{
gen prro`guau'=rnormal()
}

foreach miau of numlist 2(3)9 11/13 15 21{  // solo valido para foreach
gen  gato`miau'=rnormal()
}

foreach mu of varlist ingxh* horas{
gen ln_`mu'=ln(`mu')
}

local repet=1
foreach cua in carro id 3{
if `repet'==1 gen pato_`cua'="`cua'"
else gen pato_`cua'=`cua'
local repet=`repet'+1
}

gen equis=.
forvalues x=1/100{
replace equis=`x'^2 in `x'/`x'
}

gen equis2=_n^2

levelsof dpto // categóricas
levelsof dominio, local(caracol)
*macro list
foreach vee of local caracol {
egen prom_`vee'=mean(horas) if dominio==`vee'
*egen prom_1=mean(horas) if dominio==1
}

*Para calcular un promedio en todas las columnas (no solo en las del if)
*egen E=mean(D)


levelsof dpto, local(oruga)
local repet=1
foreach vee of local oruga{
egen promd_`repet'=mean(horas) if dpto=="`vee'"
*egen prom_La Libertad=mean(horas) if dpto=="La Libertad"
*Cuidado con los nombres de las variables que contengan espacio
local repet=`repet'+1
}

*BUCLE ABIERTO
use datos1, clear

*Muestra aleatoria de 10 observaciones con ingxh promedio>10
*(RETO: 7 hombres 3 mujeres)

bro ingxh sexo
sort ingxh

gen alea=rnormal()
local cont=0
while `cont'!=1 {
replace alea=rnormal()
sort alea
sum ingxh in 1/10
local prom_m=r(mean)
sum sexo in 1/10
local prom_s=r(mean)
if `prom_m'>10 & `prom_s'==0.3 gen muestra=ingxh in 1/10
if `prom_m'>10 & `prom_s'==0.3 local cont=`cont'+1
}

gen alea=rnormal()
local prom_m=0
local prom_s=0
while (`prom_m'<10)|(`prom_s'!=0.3) {
replace alea=rnormal()
sort alea
sum ingxh in 1/10
local prom_m=r(mean)
sum sexo in 1/10
local prom_s=r(mean)
if (`prom_m'>10 & `prom_s'==0.3) gen muestra=ingxh in 1/10
}

gen alea=.
local prom=0
while `prom'<10{
qui replace alea=rnormal()
sort alea
qui sum ingxh in 1/10
local prom=r(mean)
}
sum ingxh in 1/10

*quietly qui comando, aún con ctrl+d, no imprime resultados
*noisily n comando, aún con ctrl+r, imprime resultados

bro sexo ingxh
gen nobs=cond(sexo==1,3,7)
*cond(,,) equivale a =SI(,,)
gen aleat=rnormal()
sort sexo aleat
bys sexo: gen orden=_n
sum ingxh if orden<=nobs


*MANEJAR BASES DE DATOS
dir

*Quiénes son las observaciones? (ID)
*Qué información tengo?

use gr_fiscal_2014.dta, clear 
isid ao			//no
isid dpto		//si
isid ao dpto	//si
use gr_fiscal_2015.dta, clear
isid dpto
use gr_poblacion.dta, clear
isid ao dpto
use gl_fiscal.dta, clear
isid ao prov
isid ao dpto prov

*master: cargada en memoria
*using bd que quiero agregar
use gr_fiscal_2014, clear
append using gr_fiscal_2015
	*del mismo tipo (str con str, num con num)
	*etiquetas representan a misma categ
	*misma info - mismo nombre

	*matched(3) -> bien emparejadas
	*master only (1) -> missing
	*using only(2)
	
merge 1:1 ao dpto using gr_poblacion, nogen keep(1 3) // nogen -> no genera columna _merge , keep -> qué valores (filas) quiero mantener
	 *m:u											  // keepus(varlist) -> mantiene columnas
merge 1:m ao dpto using gl_fiscal
	 *m:u (dptos:provincias, 1 dpto contiene m provincias - 1:m)

*ENAHO 2017
*ENAHO 2007
*MÓDULOS 1 2 3 5 34
