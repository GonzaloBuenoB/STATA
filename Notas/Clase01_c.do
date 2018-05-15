*modo 1 de colocar comentarios
display 2*3 //Causita
display /* imprime resultados*/ 2^10
display 2+1+ ///
2+3

*ctrl + d (imprime resultados)
*ctrl + r (sin imprimir en resultados)
query

*COMANDOS BÁSICOS
cd "D:\STATA GG"
dir
dir *.dta //* comodín reemplaza n caracteres
help cd

*IMPORTAR DATA
clear
import excel "D:\STATA GG\datos0.xlsx", sheet("Sheet1") firstrow clear

*SINTAXIS
summarize 
sum
*comodín solo en varlist

sum edad horas
sum edad-horas
sum ing*
sum ?d* //? comodín un caracter

sum edad in 1/100
sum edad if sexo=="mujer"
sum edad if sexo=="mujer" | edad >40

bys sexo: sum //para categorías
bys sexo sector: sum

sum edad in 1/100 if sexo=="mujer"
bys sexo: sum ing if edad>40
*bys sexo: sum ing in 1/100

sum edad, d
display r(p50)
sum ing if edad>r(p50)
ret list //return list
sum edad if ing>r(mean)

*BASES DE DATOS
clear //equivale a wf u 100
set obs 100

use datos1, clear
*solo mayores de 40, id ing*, de datos1
use id ing* edad if edad>40 using datos1, clear
save borrar_mas_tarde, replace

sysuse auto,clear
sysuse dir,all

*COMANDOS PARA EXPLORAR
bro
edit


