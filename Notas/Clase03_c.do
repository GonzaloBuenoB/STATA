cd "D:\STATA GG"
use datos1.dta, clear

bro id
* Conglomerado - Vivienda - Hogar - Cod Persona
* 01 Jefe de Familia

split id, gen(lol) parse(-) destring
destring lol1, replace
tostring lol2, replace

bro sexo dpto
egen babosa=concat(sexo dpto)
egen babosa2=concat(sexo dpto), punct(" de ") decode

bro id
gen nhogares=substr(id,-4,1)
gen nhogares2=real(nhogares) // replace no cambia tipo de variable
gen nhogares3=real(substr(id,-4,1))
bro if nhogares2>1
bro if real(substr(id,-4,1))>1

*egen (help egen)	 | no replace | no se puede usar más de una | siempre con egen
*gen (help function) | si replace | si puedo usar más de una | con gen o con if


*COMANDOS DE PROGRAMACIÓN
use datos1, clear
*MACROS
global lechuga = "id sexo edad ing*"
sum edad
global prome=r(mean)
global carpeta "D:\STATA GG"

desc $lechuga // pierde comillas
sum ingxh if edad>$prome
cd "$carpeta"	

local prro edad dpto sector
local gatusso=7
local alan "D:\STATA GG"
local huskey `prro' ingxh horas

count if ingxh>`gatusso'
desc `prro'
desc `lobo'
local gatusso=`gato'+1
cd `raton'

macro list
macro drop prome

*ESCALAR
scalar A = ln(10)
sum edad
scalar B = r(max) // TRUCAZO: Crealas con mayusucula
scalar list
scalar drop A
scalar drop _all
scalar list

*MATRICES
matrix HOLA = J(4,8,.)
matrix list HOLA
matrix HOLA[2,5] = 3
matrix HOLA[1,3] = edad[2]
matrix list HOLA

matrix C = J(2,3,1)
matrix D = J(10,3,2)
matrix E = J(12,4,3)
matrix F=C\D
matrix G=F,E
matrix list G

scalar list
matrix dir
matrix list HOLA
matrix drop F

mean ingxh
ret list

matrix list r(table)
matrix caracol = r(table)
matrix list caracol
scalar errest=caracol[2,1]
scalar list errest

matrix G=matuniform(100,5)
matrix list G

svmat G // transforma matriz en base de datos
bro
mkmat edad ingxh* in 2/11, matrix(H) // transforma base de datos en matriz (no pueden haber textos)
matrix list H

*CONDICIONALES
clear all
matrix dir
scalar list
macro list

use datos1, clear
gen alea = rnormal()
sum alea
scalar prom=r(mean)

if prom>0{
count
}

if prom>0 count //si prom>0, cuenta, d.o.m. no hace nada

count if alea>0 //cuenta las observaciones con alea>0
				//sí o sí va a contar (ejecutar el comando)
if alea>0 count // alea[1]>0, cuenta todas las observaciones
				//d.o.m. , no hace nada
				
*if cond1 count if cond*

if prom>0{
desc
}
else {
count
}

if prom>0 desc
else count
