cd "D:/STATA GG"

use datos3, clear

*GRÁFICOS DE UNA VARIABLE

*BARRAS

gr bar ingxh? (p50) ingxh? [pw=fac]
gr bar ingxh [pw=fac], over(sector) over(sexo)
gr bar ingxh [pw=fac], by(sexo sector)
gr bar ingxh [pw=fac], over(sexo) over(sector) over(gedad)
						*leyenda	columna		supercol
						
gr hbar (sum)horas [pw=fac], over(sexo) over(neduc) ///
							asyvar stack percent //perc
*asyvar: transforma en leyenda al primer over
* el #% de las horas trabajadas por persona con --- fueron trabajadas por hombres/mujeres

gr hbar (sum) ing? if ing2!=. [pw=fac], over(neduc) ///
							stack perc // no es necesario asyvar porque ya hay 2 colores

*GRÁFICOS DE DOS VARIABLES

scatter ingx ingh edad
line ingxh edad, sort
tw lfit ingxh edad [pw=fac]

collapse (p50) ingxh [pw=fac], by(edad)
scatter ingxh edad
tw (qfitci ingxh edad) (scatter ingxh edad), ///
	title("Relación entre edad e ingreso por hora") ///
	ytitle("Ingreso por hora") xlabel(20(10)100) ///
	legend(order(3 "Mediana" 2 "Valor Predicho" 1 "Intervalo de Confianza 95%"))

*help twoway

*ESTADÍSTICA INFERENCIAL
************************
use datos3, clear
svyset conglome [pw=fac], strata(estrato) //formatea la bd si los pesos estan aquí no requiere más pesos
svydes
mean ingxh
mean ingxh [pw=fac]
svy: mean ingxh
svy: mean ingxh, level(99)

svy: mean ingxh if sexo==1 //ESTO ESTÁ MAL, CONDICIÓN NO AFECTA SVY
svy, subpop(sexo): mean ingxh
svy, subpop(if sexo==1): mean ingxh
svy: mean ingxh, over(sexo)


