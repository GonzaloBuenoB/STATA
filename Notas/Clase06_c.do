cd "D:\STATA GG"


*collapse por defecto da el promedio
*cuidado con tener variables con el mismo nombre
collapse ingxh ing1 (p50) horas oruga=ingxh [pw=fac], by(edad)

*table edad [pw=fac], replace c(mean ingxh mean ing1 p50 horas p50 ingxh)

*COLLAPSE - RESUMIR BD

*base de datos a nivel de dpto
*para personas de 25 a 54 años
*información:
*promedio de ingreso por hora
*mediana de horas trabajas en ocup principal y sec
*mediana de ingreso por hora
*proporción de personas con secundaria incom o menos

use datos3,clear
gen prop_secin=(neduc<=5) if neduc!=.
collapse ingxh prop_secin (p50) horas p50_ingxh=ingxh if inrange(edad,25,54) [pw=fac], by(dpto)
bro

*lookfor educ
*codebook neduc
*label list neduc

reshape long ingxh , i(edad sexo) j(oruga)
reshape wide ingxhF ingxhI , i(edad) j(sexo)

*RESHAPE - TRANS

*base de datos a nivel departamento
*contiene variables con información sobre:
*promedio de ingreso por hora para hombres formales
*promedio de ingreso por hora para mujeres formales
*promedio de ingreso por hora para hombres informales
*promedio de ingreso por hora para mujeres informales
*p50 de ingreso por hora para hombres formales
*p50 de ingreso por hora para mujeres formales
*p50 de ingreso por hora para hombres informales
*p50 de ingreso por hora para mujeres informales

*dpto | promHF | promHI | promMF | promMI | p50HF...
use datos3, clear
*Checar los missings
gen SEXO=cond(sexo==1,"M","H")
gen SECTOR=cond(sector==1,"F","I")
collapse prom=ingxh (p50) media=ingxh [pw=fac], by(dpto SEXO SECTOR)
reshape wide prom media, i(dpto SECTOR) j(SEXO) s
reshape wide promH mediaH promM mediaM, i(dpto) j(SECTOR) s

*dpto	|stat|ingxhHF|ingxhHI|ingxhMF|ingxhMI
*AMAZONAS|prom|x
*AMAZONAS|p50 |x
use datos3, clear
*Checar los missings
gen SEXO=cond(sexo==1,"M","H")
gen SECTOR=cond(sector==1,"F","I")

preserve //funcionan como local

collapse ingxhprom=ingxh (p50) ingxhp50=ingxh [pw=fac], by(dpto SEXO SECTOR)
reshape long ingxh, i(dpto SEXO SECTOR) j(STAT) s
reshape wide ingxh, i(dpto STAT SECTOR) j(SEXO) s
reshape wide ingxhH ingxhM, i(dpto STAT) j(SECTOR) s
save dpto_ingxh, replace

restore //funcionan como local

erase dpto_ingxh.dta

*GRÁFICOS

*UNA VARIABLE
hist ingxh [fw=round(fac)]
hist ingxh [fw=round(fac)], percent
hist ingxh [fw=round(fac)], percent kden // muestra la densidad
hist ingxh [fw=round(fac)], percent kden norm // distribución normal para comparar
gen ln_ingxh=ln(ingxh)
hist ln_ingxh [fw=round(fac)], norm
hist edad [fw=round(fac)] // no porque edad es discreta
hist edad [fw=round(fac)], d // para indicar que es discreta
hist edad [fw=round(fac)], d by(sexo sector)

kdensity ingxh [fw=round(fac)]
kdensity ingxh [fw=round(fac)], gen(caracol oruga) n(10)

gr box ingxh [pw=fac]
gr box ingxh [pw=fac], over(sector) by(sexo) 
gr box ingxh [pw=fac], over(sector) over(sexo)
						*col		scol
gr box ingxh [pw=fac], by (sexo sector)
gr box ingxh1 ingxh2 [pw=fac]
gr box ingxh1 ingxh2 [pw=fac], over(sexo)
* hasta 3 overs o 2 en caso de que haya muchas variables
*Diferente color -> diferentes variables
*Diferentes gráficos en un mismo panel -> over
*Diferentes paneles -> by

gr bar ingxh [pw=fac] // gr bar es el collapse de los gráficos
					  // si no hay un estadístico asume el promedio
gr bar ingxh? [pw=fac]
gr bar ingxh? (p50) ingxh? [pw=fac]
gr hbar ingxh [pw=fac], over(nedu)
gr hbar ingxh [pw=fac], over(nedu) by(sexo)

*help graph bar

*RELACIÓN ENTRE DOS VARIABLES
