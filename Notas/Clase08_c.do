cd "D:\STATA GG"
use datos3, clear
svyset conglome [pw=fac], strata(estrato)

//conglome, a que niveles esteá estratificado
svy:mean ingxh //me da el promedio, el error estandar y los int.conf
svy:total ingxh 

foreach x of varlist horas*{
replace x'=x'*4
}

svy:ratio ing/horas //no está bien porque ing es mensual y horas es semanal
svy:ratio (princ:ing1/horas1) (sec:ing2/horas2)
svy:proportion sector //frecuencias relativaas con intervalos de confianza, es el porcentaje de trabajadores que son informales
svy:proportion sector,over(sexo) //es el % de mujeres son informales.
svy:proportion sexo,over(sector)  //el % de personas informales son mujeres
svy:tab sexo sector //lo importante es lo que dice Pearson
//comando mean ingxhcalculo el ratio para cada persona y promedio ese ratio*dividioendo entre todas las horas que trabajaron, se usa mas en el mundo micro. Se tiene los datos de cada observacion.
//comando ratio:con ratio es data mas macro, no se tienen muchos datos, entonces uso ratios entre tosas las horas

*PRUEBAS DE HIPÓTESIS

svy: mean ingxh
ret list
eret list
lincom ingxh-5		//h0: u_ingxh=5

svy: mean ingxh1 ingxh2
eret list
matrix list e(b) // matriz de coef.
matrix list e(V) // matriz de cov
lincom ingxh1-ingxh2

svy: mean ingxh, over(sexo)
lincom [ingxh]hombre -[ingxh]mujer

*¿el beneficio adicional sobre le ingreso
*por hora por pertenecer al sector formal
*en lugar del sector informal es mayor
*para las mujeres o para los hombres?

svy: mean ingxh, over(sexo sector)
lincom ([ingxh]_subpop_2 - [ingxh]_subpop_1) - ([ingxh]_subpop_4 - [ingxh]_subpop_3)

*con 95% de confianza rechazo la h0 de que sean iguales
*se puede afirmar que es mayor para las mujeres

lincom ([ingxh]_subpop_2 - [ingxh]_subpop_1) - ([ingxh]_subpop_4 - [ingxh]_subpop_3), level(99)
*con 99% de confianza, no puedo rechazar la h0
*es posible que el beneficio adicional sea igual para ambos

*CORRELACIONES SIMPLES Y PARCIALES

cor ingxh horas [aw=fac]
ret list
matrix list r(C)
pwcorr ingxh horas [aw=fac]
pwcorr ingxh horas edad ing [aw=fac], sig	// p values no son correctos, no se permite svy
											// por lo tanto solo sirven de referencia
pwcorr ingxh horas edad ing [aw=fac], star(95)

svy: reg ingxh horas // ols
svy: reg ingxh sexo
svy: reg ingxh horas sexo
svy: reg ingxh horas sexo edad
svy: reg ingxh horas sexo edad c.edad#c.edad
svy: reg ingxh horas sexo c.edad##c.edad // con ## asume que es la lineal y la cuadrática
svy: reg ingxh horas sexo edad i.neduc // usa la de menor valor como la base
									   // Yinicial - Ysin nivel
svy: reg ingxh sexo#sector
/*
---------------------------------------------------------------------------------
                |             Linearized
          ingxh |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
----------------+----------------------------------------------------------------
    sexo#sector |
 hombre#formal  |   3.639155   .0796455    45.69   0.000     3.483015    3.795295
mujer#informal  |  -.7339753   .0482692   -15.21   0.000    -.8286041   -.6393466
  mujer#formal  |   3.153114   .1001208    31.49   0.000     2.956833    3.349394
                |
          _cons |   5.033905   .0342186   147.11   0.000     4.966822    5.100988
---------------------------------------------------------------------------------
*/
svy: reg ingxh sexo##sector
/*
-------------------------------------------------------------------------------
              |             Linearized
        ingxh |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
--------------+----------------------------------------------------------------
         sexo |
       mujer  |  -.7339753   .0482692   -15.21   0.000    -.8286041   -.6393466
              |
       sector |
      formal  |   3.639155   .0796455    45.69   0.000     3.483015    3.795295
              |
  sexo#sector |
mujer#formal  |   .2479341   .1206672     2.05   0.040     .0113734    .4844948
              |
        _cons |   5.033905   .0342186   147.11   0.000     4.966822    5.100988
-------------------------------------------------------------------------------
*/

* ## es la doble derivada para cada valor, varía cuando las dummies son 1
* # cada subpoblación respecto a una base

// # multiplicar
// c. continua
// i. categórica
