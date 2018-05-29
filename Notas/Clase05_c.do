cd "D:\STATA GG"
use datos3, clear
bro
desc
codebook estrato

*ponderar: considera proporción de pob total
*expandir: considera cantidad de personas

tab neduc
*4.35% de los encuestados no recibió educ
*1996 encuestados no recibió educ
tab neduc [aw=fac]	// pondera pero no expande, sus absolutas no funcionan
*2.54% de la población no recibió educ
*1668 peruanos no recibió educ MAL
tab neduc [fw=round(fac)]	// pondera y expande
*2.54% de los peruanos no recibio educ
*325.890 peruanos no recibió educ
tab neduc [iw=fac] // pondera y expande
*2.54% de los peruanos no recibio educ
*325.903.27  peruanos no recibió educ

*tab neduc [pw=fac]	tab no permite pw

*Si es un muestreo simple (como un censo) no usar pesos
*Cada observación se representa a si misma
*Si no se admite pweights usar cualquier otro

*PERCENTILES
use datos3, clear
bro ingxh
sort ingxh
xtile quintiles=ingxh [pw=fac], nq(5)
pctile cortes5=ingxh [pw=fac], nq(5)
tab quintiles [iw=fac]

*TABLAS DE FRECUENCIAS

*DE UNA VARIABLE
tab neduc [iw=fac]
tab neduc [iw=fac], m
*tab neduc [iw=fac], nol m
label list neduc
tab neduc [iw=fac], gen(hola)
	bro neduc hola*
	drop hola*
tab neduc [iw=fac], plot

*DE DOS VARIABLES
tab neduc sector [iw=fac]
tab neduc sector [iw=fac], row col cell
tab neduc sector [iw=fac], nofreq row
tab neduc sector [iw=fac], nofreq col
tab neduc sector [iw=fac], nofreq cell

*TABLAS DE ESTADÍSTICOS
***********************

*ESTADÍSTICOS FIJOS
sum ingxh [aw=fac], d

*MISMOS ESTADÍSTICOS DE VARIA VARIABLES
tabstat ing? [aw=fac], save
ret list
matrix list r(StatTotal)
tabstat ing? [aw=fac], stat(mean cv q)
tabstat ing? [aw=fac], stat(mean cv q) c(s)

tabstat ing? [aw=fac], by(neduc)
tabstat ing? [aw=fac], by(neduc) not m
bys sexo: tabstat ing? [aw=fac], by(neduc) not m save
ret list

*POCOS ESTADÍSTICOS DE POCAS VARIABLE PARA VARIAS SUBPOBLACIONES
table sector [pw=fac]
*Solo 5 variables
table sector [pw=fac], c(mean ingxh p50 horas)
table neduc sector sexo [pw=fac], c(mean ingxh)
	  *row  col	   scol
table neduc sector sexo [pw=fac], c(mean ingxh) row col scol
table neduc sector sexo [pw=fac], c(mean ingxh) by(gedad) replace
