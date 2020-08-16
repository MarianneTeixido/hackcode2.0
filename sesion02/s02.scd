//Hackcode. Composición Algorítmica en tiempo real.
//Agosto, 2020
//Festival Sur Aural
//Licencia GNU General Public License v3.0



Sesión 2.


_________________________

FILTROS
_________________________


s.boot

Un filtro es un sistema que realiza un proceso de discriminación de una señal de entrada para obtener variaciones en su salida. Un filtro de audio está diseñado para dejar pasar determinadas segmentos de frecuencia y no dejar pasar otras.


En los filtros que usaremos, el primer argumento indica la señal que será filtrada y el segundo argumento es su frecuencia de corte.

Los tres filtros que veremos a continuación pueden funcionar tanto con .ar como con .kr.

La condición al usarlos es que la señal que se quiera filtrar tenga el mismo rate que el filtro.


//________ H P F  - High Pass Filter (Filtro Pasa Altas)


Es aquel que permite el paso de frecuencias desde una frecuencia determinada hacia arriba, sin que exista un límite superior especificado. Esta frecuencia determinada es la frecuencia de corte. Por ejemplo, si determinamos que sea 700Hz la frecuencia de corte dejaremos pasar todas las frecuencias mas altas que 700 Hz.


{HPF.ar(in:, freq:, mul:, add: )}; //Sintaxis


//Argumentos:

in: //señal que filtraremos. Tiene que tener .ar
freq: //frecuencia de corte
mul: //multiplicación
add: //adición


{HPF.ar(WhiteNoise.ar(0.1), 7030)}.scope


Aqui un WhiteNoise es filtrado por un pasa altos dejando pasar frecuencias arriba de los 7030 Hz



//________ L P F - Low Pass Filter (Filtro Pasa Bajas)
Es aquel que permite el paso de frecuencias bajas, desde la frecuencia 0 hasta una frecuencia determinada. Esta frecuencia determinada es la frecuencia de corte. Por ejemplo, si determinamos que sea 200 Hz la frecuencia de corte dejaremos pasar todas las frecuencias mas bajas que 200 Hz. Es importante recordar que no hay frecuencias menores a 0 Hz.
//Los argumentos son los mismos que los del HPF.

{LPF.ar(WhiteNoise.ar(0.1),7030)}.scope // Aqui lo contrario: pasan las frecuencias debajo de los 7030 Hz




////________ B P F - Band Pass Filter (Filtro Pasa Banda)
Es aquel que permite el paso de frecuencias contenidas dentro de un determinado rango o banda, comprendido entre una frecuencia inferior y otra superior. La distancia entre estas frecuencias determina el ancho de banda. La frecuencia que está en el centro de esta distancia es la frecuencia de corte. Por ejemplo, si determinamos que sea 1000 Hz la frecuencia de corte y 200 Hz el ancho de banda podemos saber cual es el rango de frecuencias que dejaremos pasar usando la siguiente

//fórmula:

//cota inferior = frecuencia de corte - ancho de banda/2
//cota superior = frecuencia de corte + ancho de banda/2

La cota superior es la frecuencia límite superior y la cota inferior es la frecuencia límite inferior.

Si sabemos cuáles son las cotas inferior y superior que queremos entonces podemos obtener el ancho de banda y la frecuencia de corte con la siguiente fórmula:

//ancho de banda = cota superior - cota inferior
1100 - 900

//frecuencia de corte = cota superior - ancho de banda/2
1100- (200/2)

// o frecuencia de corte = cota inferior + ancho de banda/2
900 + (200/2)

El BPF no es el único filtro que usa un ancho de banda. En los filtros de este tipo el ancho de banda no puede escribirse como un argumento. Para establecer el ancho de banda, SC utiliza el factor de calidad del filtro, que es un parámetro que mide la relación de energía que dispersa el filtro y la que almacena. Este factor es conocido como Q y es igual a la frecuencia de corte/ancho de banda. Entonces, en vez del ancho de banda, usamos el recíproco de Q, ya que esto le ahorra al programa una división adentro del UGen. El recíproco de Q se representa así Q/1 = 1/Q. Por consiguiente: rq= ancho de banda /frecuencia de corte.


//Argumentos:
in: //señal de entrada
freq: //frecuencia de corte en Hz
rq: //recíproco de Q, es decir el ancho de banda / frecuencia de corte.
mul: y add:

{ BPF.ar(WhiteNoise.ar(0.1), 7000, 700/7000)}.scope // El tercer argumento del pasa banda es el reciproco de q.

//En este ejemplo tenemos ancho de banda=700 y frecuencia de corte=7000.
700/7000 = 0.1
//Por lo tanto
rq=0.1

//A veces es mas rápido escribir el número decimal que el quebrado. Veamos entonces como queda sustituyendo del ejemplo anterior:
{BPF.ar (WhiteNoise.ar (0.1), 7030, 0.1)}.scope
{BPF.ar (WhiteNoise.ar(0.1), 7030, 1)}.scope // Aquí tenemos otro valor para el rq.

//___N O T A
//Hay señales que se prestan a ser filtradas y otras que no. Por ejemplo, una senoide (SinOsc) no se presta a ser filtrada porque sólo contiene una frecuencia. No existe nada más arriba ni más abajo de esa frecuencia para ser retirado. Los ruidos, que son un conjunto complejo de 18 frecuencias son los que dan resultados más notables al ser filtrados.


//Ejemplo de Hi Hat con WhiteNoise, un filtro, decaimiento y un secuenciador.

{(RHPF.ar(WhiteNoise.ar(0.3),[500,5100,4000],1))*Decay.kr(Demand.kr(Impulse.kr(1),0,Dseq([1,1,1,1],inf))*Impulse.kr(1),0.09)*3}.play




_________________________

INTERACTIVIDAD CON MOUSE
_________________________



//Una forma de controlar los argumentos de los UGens en SuperCollider es a través de las Clases MouseY, MouseX y MouseButton. Estas clases son UGens de control por lo que trabajan con el mensaje kr. Los argumentos principales de los UGens MouseY y MouseX son el valor mínimo y el valor máximo que queremos obtener al mover nuestro mouse. En MouseButton los argumentos son el valor cuando el mouse no está apretado y cuando si.

MouseX.kr(0,100) // nos da números desde 0 (cuando el mouse está totalmente a la izquierda) hasta 100 (cuando el mouse está en el extremo derecho).

MouseY.kr(0,100) // nos da números desde 0 (cuando el mouse esta completamente arriba) hasta 100 (cuando el mouse está totalmente abajo).

MouseButton.kr(0,1) // Cuando no esta apretado tengo el valor 0 y cuando si el valor 1.

//________

{SinOsc.ar(MouseY.kr(1000,100))}.scope // Puedo hacer un barrido desde la frecuencia 100Hz cuando el mouse esta abajo hasta 1000 Hz cuando el mouse esta hasta arriba.

{SinOsc.ar(400,0,MouseX.kr(0,1))}.scope // Amplitud 0 cuando el mouse esta en el extremo izquierdo hasta 1 cuando el mouse esta en el extremo derecho.

{SinOsc.ar(MouseX.kr(1000,100),0,MouseY.kr(0,1))}.scope // Mezclando los dos ejemplos anteriores con MouseY y MouseX

{Pulse.ar(MouseY.kr(10000,20),MouseX.kr(0.001,0.5),MouseButton.kr(0,1))}.scope

//Los mismos ejemplos de filtros usando la clase MouseY y MouseX
{HPF.ar(WhiteNoise.ar(0.1),MouseY.kr(10000,1000))}.scope
{LPF.ar(WhiteNoise.ar(0.1),MouseX.kr(10000,100))}.scope
{BPF.ar(WhiteNoise.ar(0.1),MouseY.kr(10000,1000), 0.05)}.scope
{BPF.ar(WhiteNoise.ar(0.5), 130,MouseX.kr(0.05,1.5))}.scope
{BRF.ar(WhiteNoise.ar(0.1),MouseY.kr(10000,1000),MouseButton.kr(0,1))}.scope
{BRF.ar(WhiteNoise.ar(0.1), 7030,MouseX.kr(0.05,1.5))}.scope





_________________________

EJERCICIO
_________________________


/* 1 */
{LPF.ar(BrownNoise.ar(0.5),___)}.scope

/* 2 */
{HPF.ar(Pulse.ar(___,0.75)*WhiteNoise.ar(__),10000)}.scope

/* 3 */
{Saw.ar(__,0.75)*BPF.ar(WhiteNoise.__(1),10000)}.scope

/* 4 */
{_______.ar(Saw.ar(2,0.6),3000,100/3000)+BPF.ar(_______.ar(3,0.4),_______,50/500)}.scope

/* 5 */
{LFTri.ar(1,0,1)*LPF.ar(_______.ar(30,0.1,1),1000)}.scope

/* 6 */
{Pulse.ar(117,_______.kr(0.5,0.01),0.5)}.scope

/* 7 */
{_______.ar(MouseX.kr(60,800),0,0.6)}.scope

/* 8 */
{_______.ar(_______.ar(100),MouseY.kr(15000, 160),60/MouseY.kr(15000,160))}.scope

/* 9 */
{Pulse.ar(_______.kr(5,20))_______(SinOsc.ar (10000,0,0.6)_______SinOsc.ar(90,0,0.6))}.scope

/* 10 */
{Pulse.ar(MouseY.kr(110,90),_______,0.5)*_______.ar(100,0.1,0.5)}.scope




_________________________

CANALES
_________________________



Pan.ar (señal,posición)
//Distribuye el sonido entre dos canales consecutivos conservando su potencia. Es decir, que no suena más fuerte cuando esta en los dos canales al mismo tiempo ni más quedito cuando está solo en uno o en otro. Si el Pan2 esta dentro de un Out los canales consecutivos en los que se distribuyen se cuentan a apartir del offset del Out.

señal: //cualquier oscilador o generador de sonido
posición: //-1 izquierda, 1 derecha y con todo el intervalo continuo extrapolando el sonido entre los dos canales o bocinas.

{Pan2.ar(Pulse.ar(100,0.01),MouseX.kr(-1,1))}.scope {Pan2.ar(Pulse.ar(100,0.01),-0.7)}.scope {Pan2.ar(Pulse.ar(100,0.01),0)}.scope // En medio.
{Pan2.ar(Pulse.ar(100,0.01),0.3)}.scope {Pan2.ar(Pulse.ar(100,0.01),1)}.scope
{Out.ar(0,Pan2.ar(Dust.ar(1000),0))}.scope // distribuye la señal entre el canal 0 y 1
{Out.ar(1,Pan2.ar(Dust.ar(1000),0))}.scope // distribuye la señal entre el canal 1 y 2. Si no tenemos una interfase de audio que nos permita expandir los canales solo se va a escuchar al canal 1. Sólo tenemos 2 canales en nuestras computadoras que el Collider reconoce como el 0 y el 1.




_________________________

LENGUAJE
_________________________


.midicps // convierte un número de código MIDI a su equivalente en frecuencia en Hertz. .cpsmidi // convierte una frecuencia en Hertz a su equivalente en código MIDI.

//El código MIDI para designar las notas es:
60=Do (índice 5 o central) 61=Do # o Re b
62=Re
63=Re # o Mi b
26
64=Mi
65=Fa
66=Fa # o Sol b
67=Sol
68=Sol # o La b
69=La
70=La # o Si b
71=Si
72=Do //(índice 6. Una octava arriba del Do índice 5)


//Si queremos convertir el código MIDI 60 (Do) en frecuencia en Hertz lo hacemos mandándole el mensaje .midicps (cps=ciclos por segundo).

60.midicps
69.midicps

//Para el inverso aplicamos el mensaje cpsmidi
//Te permite cambiar de ciclos por segundo a notas midi.

261.6255653006.cpsmidi 440.cpsmidi


.midiratio // convierte intervalos en razones o quebrados


//Los intervalos para usar con el mensaje midiratio son expresados en cantidad de semitonos.
//Está relacionado con el método de Forte para los pitch class(altura de clase) sets:
0 = unísono
1 = segunda menor
2 = segunda mayor
3 = tercera menor
4 = tercera mayor


5 = cuarta justa
6 = tritono
7 = quinta justa
8 = sexta menor
9 = sexta mayor
10 = séptima menor
11 = séptima mayor
12 = octava

//Los números negativos denotan intervalos descendentes. Entonces para aplicar este mensaje mandamos el mensaje . midiratio al intervalo que deseamos obtener y lo multiplicamos por una frecuencia fundamemntal que nosotros damos. Ejemplo:

440 * 3.midiratio // nos da una tercera menor a partir de La.
440 * -5.midiratio // nos da una carta descendente a partir de La.


Array  //Un conjunto de elementos ordenados. Se escriben dentro de corchetes [ ] y se separan por comas.

['hola', 'hi', 'salud', 'hallo']
[0,1,2,3,4]
[0,1,2,3,4].choose
[60,62,64,65,67].midicps // Nota 1
[ 261.6255653006, 293.66476791741, 329.62755691287, 349.228231433, 391.99543598175 ].cpsmidi




//_____ESCALAS
//Diferentes escalas usando el código MIDI.
[60,62,64,65,67,69,71,72].midicps // un array con las notas de la escala mayor
[60,62,63,65,67,68,70,72].midicps // un array con las notas de la escala menor natural
[60,62,64,66,68,70,72].midicps // la escala de tonos enteros
[60,62,63,65,66,68,69.72].midicps // La escala simétrica tono, 1/2tono
[60, 61, 63, 64, 66, 67.72, 71].midicps // La escala simétrica 1/2tono, tono

//Las mismas escalas expresadas en intervalos y usando midiratio

[ 0, 2, 4, 5, 7, 9, 11, 12 ].midiratio // un array con las notas de la escala mayor
[ 0, 2, 3, 5, 7, 8, 10, 12 ].midiratio // un array con las notas de la escala menor natural
[ 0, 2, 4, 6, 8, 10, 12 ].midiratio // la escala de tonos enteros
[ 0, 2, 3, 5, 6, 8, 9, 12 ].midiratio // La escala simétrica tono, 1/2tono
[ 0, 1, 3, 4, 6, 7, 12, 11 ].midiratio // La escala simétrica 1/2tono, tono

//Para convertir las escalas expresadas en MIDI en el primer conjunto de arrays a las escalas expresadas en intervalos del segundo conjunto basta con restarles 60. Veamoslo en el primer ejemplo de las escala mayor.
[60,62,64,65,67,69,71,72]-60 == [ 0, 2, 4, 5, 7, 9, 11, 12 ]




_________________________

 ENVOLVENTES
_________________________


La envolvente es la manera en que se despliega un sonido en función del tiempo y la amplitud. Estamos hablando de qué tan fuerte suena nuestro timbre a medida que pasa el tiempo. Por ejemplo una envolvente percusiva es como la de un tambor o un piano, en donde el sonido comienza muy fuerte e inmediatamente se va escuchando mas quedito. Los elementos de la envolvente más comunmente identificados son:



ataque (attack): //que tan rápido alcanza nuestro sonido su punto de máxima amplitud.

decaimiento (decay): //que tan rápido alcanza nuestro sonido su punto de estabilidad o sostenimiento.

sostenimiento (sustain): //cuanto tiempo está nuestro sonido en el punto de estabilidad en el que no sube ni baja de amplitud.

liberación (release): //el tiempo que tarda el sonido en llegar del punto de sostenimiento a la amplitud cero.



A las envolventes que tienen estos cuatro parámetros bien definidos se les conoce como envolventes ADSR. No todas las envolventes tienen estos mismos elementos, algunas tienen sólo dos: ataque y liberación, o sólo tres: ataque, sostenimiento y liberación.

Para generar una envolvente en SuperCollider recurrimos a la clase EnvGen. Las envolventes pueden ser pensadas como una secuencia de números que se despliega en el tiempo. Esta secuencia puede ser usada para varios propósitos que pueden involucrar una forma de onda o una modulación. Por el momento nuestras envolventes no generarán sonido, sólo determinarán la manera en que su amplitud se desarrolla en el tiempo, asi que EnvGen trabajará con el rate de control .kr.



//_________EnvGen.kr
//Genera una envolvente que puede dar forma a la amplitud de nuestro sonido.

EnvGen.kr (envolvente,gate,doneAction:2)

envolvente: //En el argumento envolvente colocamos alguna de las muchas envolventes que posee SuperCollider en la clase Env.





//__ADSR

Env.adsr (ataque, decaimiento, volumen, relajamiento )
//Envolvente de duración indeterminada para sonidos sostenidos. El segundo argumento es de volumen, no de duracion.






//__PERC

Env.perc (ataque, liberación)
//Envolvente de ataque percusivo, argumentos en segundos. Duración determinada por la suma del attack más el release.

//Ejemplo:
Env.perc (0.01,1).plot // Aquí el attack dura 0.01 segundos y el release 1 segundo 0.01 + 1 = 1.01. Observar que con el mensaje .plot podemos ver la gráfica de la envolvente






//__ASR

Env.asr (ataque, volumen, decaimiento )
//Envolvente de duración indeterminada para sonidos sostenidos. El segundo argumento es de volumen, no de duración.

Env.asr(0.01,1,1).plot // Se tardará una centésima de segundo en alcanzar su amplitud máxima, que es 1 como lo indica el segundo argumento. Una vez alcanzada se quedará ahí hasta que nosotros le indiquemos cuando generar el release que se tardará 1 segundo en alcanzar el cero.

gate: 1 //abre la envolvente, 0 la cierra. Default 1. Las envolventes de duración determinada como Env.perc no necesitan cerrarse.

doneAction: //una acción que se realiza cuando la envolvente ha finalizado. doneAction: 2 elimina el Synth del servidor.



//Para aplicar la envolvente a un sonido multiplicamos la envolvente por el sonido.
//Ejemplos:

{Saw.ar(40)*EnvGen.kr(Env.perc(0.1,0.1),doneAction:2)}.scope

{Saw.ar(40)*EnvGen.kr(Env.asr(1,1,4),Line.kr(1,0,2),doneAction:2)}.scope






_________________________

EJERCICICIOS
_________________________


{----.ar(0,SinOsc.ar)}.scope;

{Pan2.ar(WhiteNoise.ar,----)}.scope;

{Out.ar(1,Saw.ar(100)*EnvGen.kr(--Env--.perc(0.01,2),doneAction:----2))}.scope;

{----.ar(WhiteNoise.ar, [100,200,400,1000,1500,5000].----,0.1)*EnvGen.kr(Env.perc(0.01,0.5),doneAction:2)}.play;

{Pan2.ar(SinOsc.ar([60,64,67,72].choose.----),[----,----].choose)}.play; {[LPF,HPF].----.ar(BrownNoise.ar,800)}.play;




//____________ Otros ejemplos
{LPF.ar(Pulse.ar(20,0.1,0.5)*SinOsc.ar(800,0,0.7),500,0.5)*EnvGen .kr(Env.asr(0.01,1,0.5),SinOsc.kr(1))!2}.play

{LPF.ar(Pulse.ar(20,0.1,0.5)*SinOsc.ar(800,0,0.7),500,0.5)*EnvGen .kr(Env.perc(0.01,0.1),SinOsc.kr(7))!2}.play

{LPF.ar(Pulse.ar(20,0.1,0.5)*SinOsc.ar(800,0,0.7),MouseY.kr(10000 ,70),0.5)*EnvGen.kr(Env.perc(0.01,0.1),SinOsc.kr(MouseX.kr(1,50)) )!2}.play





//Ejemplo envolvente en modo SynthDef

SynthDef("prueba", {|gate|
Out.ar(0,Pulse.ar(15)*EnvGen.kr(Env.asr(0.01,1,3),gate,doneAction:2))}).send(s)

a=Synth("prueba", ["gate", 1]) // Lo prenden
a.set("gate", 0) // Lo apagan





_______________________________________________________________________________________
_______________________________________________________________________________________


                           SEGUNDA PARTE

                  ESTRUCTURAS PARA SINTETIZADORES

_______________________________________________________________________________________
_______________________________________________________________________________________





_________________________

VARIABLES
_________________________



//Las variables son espacios virtuales de memoria que sirven para guardar información.
//-El concepto de variable es inherente a los lenguajes de programación.
//-Las variables facilitan la organización del código, permitiendo una clara y legible escritura.
//-Son identificadas por medio de un nombre que generalmente se relaciona con el objeto al cual queremos igualarlo. Este nombre lo definimos nosotrxs.
//-No tenemos un número determindo de variables, podemos declarar cuantas nos sean necesarias.
//-No deben usarse palabras o letras que ya estén reservadas por el sistema como s (server)

//Pasos para definir variables:
// 1. Escribimos var (abreviatura de variable)
// 2. dejamos un espacio
// 3. declaramos las variables
// 4. Al finalizar la declaración usamos un ;


//Ejemplo:
//Compila el código y observa la post.


//bien
(
var gato, dos;
gato=1;
dos=2;
gato+dos
)

//mal, observa que contesta la post
(
gato=1;
dos=2;
gato+dos
)

//Las variables que tengan un sólo caracter no necesitan ser declaradas. La letra s ya está reservada para el servidor, así que es mejor no usarla. Recuerda que las variables deben comenzar con minúscula.

//Ejemplo de variables de un solo caracter

(
a=1;
x=2;
a+x
)

//Ejemplo en donde incluimos la operación con las variables dentro de un array.

(
var gato, dos;
gato=1;
dos=2;
[gato+dos,'dos variables']
)

//Tambien podemos darle valor a la variables en el lugar donde la declaramos.

(
var gato=1,dos=2;
gato+dos
)

//Para escribir nombres largos y estrafalarios.
//utilizamos el guión bajo en lugar del espacio.
//Tambien se pueden usar mayusculas.

(
var un_numero_mayor_a_diez=15,un_numero_mayor_a_20=43; un_numero_mayor_a_diez + un_numero_mayor_a_20
)

(
var unNumeroMayorADiez=15,unNumeroMayorA20=43; unNumeroMayorADiez + unNumeroMayorA20
)


//Ahora con señales de audio
(
{var ruido,senoide;
ruido=WhiteNoise.ar(0.2);
senoide=SinOsc.ar(1000,0,0.3);
ruido+senoide
!2}.scope )


(
{
var ruido, env, senoide;
ruido=WhiteNoise.ar(0.5);
senoide=SinOsc.ar(10,0,0.3);
env=EnvGen.kr(Env.perc(0,0.2),Impulse.kr(8));
senoide*ruido*env
}.scope )

//En Macintosh, usando cmd+f (f de find) podremos encontrar con mucha facilidad palabras o símbolos dentro de un código. Una vez encontrados pueden ser sustituidas de una sola vez. (Ver en Windows y Linux que onda)


(
{
var oscilador, envolvente, impulso;
impulso = Impulse.kr(MouseX.kr(1, 10));
oscilador = LFTri.ar(200*[1, MouseY.kr(0.98, 1.0124)],0 , 0.53); envolvente = EnvGen.kr(Env.perc(0.01, 1), impulso);
oscilador * envolvente;
}.scope )

//Lo mismo pero sin sin variables...
//Para mi éste método es más inmediato :B
{EnvGen.kr(Env.perc(0.01,1),Impulse.kr(MouseX.kr(1,10)) )*LFTri.ar(200*[1,MouseY.kr(0.98,1.0124)],0,0.53)}.scope

//Ejercicio
{BPF.ar(Dust.ar(MouseY.kr(10,300)),MouseX.kr(100,2000), 0.2)*EnvGen.kr(Env.asr(2,1,4),Line.kr(1,0,8),doneAction:2)}.scope


//Ahora escríbelo usando variables.






_________________________

SYNTH DEF
_________________________



//Es una definición de sonido (creado por nosotrxs) o una definición de síntesis que puede ser invocado y manipulado independientemente de otros. Un SynthDef es el método por el cual creamos nuestros sonidos en SuperCollider.

//SuperCollider utiliza la definición de Synth 'SynthDef' como un template para la creación de synth node que es una unidad productora de sonido en el servidor.

//Un SynthDef tiene una sintáxis específica que comprende dos partes fundamentales:

//el nombre del SynthDef que se escribe como un string o un símbolo (ej :"prueba" o \prueba) por el cual podremos manipular el synth independientemente de otros synth
//y un UgenGraphFunc = una función en donde se especifíca la intercomunicación entre variables y argumentos.

//Retomaremos un ejemplo anterior:

(
SynthDef("prueba", {|gate,frecuencia=15| Out.ar(0,Pulse.ar(frecuencia)*EnvGen.kr(Env.asr(0.01,1,3),gate,doneAction:2))}).send(s) )

a=Synth("prueba",[\gate,1])
a.set(\gate,0)




_________________________

SINTAXIS   SYNTH DEF
_________________________



(
SynthDef("prueba", //el SynthDef debe de llevar un tag (nombre) que lo identifique, en este caso "prueba".

{|gate| //argumento, es el lugar destinado para los parámetros que queremos interpretar
//los argumentos son también espacios virtuales de memoria que sirven para guardar información pero esta, a diferencia de las variables es creada para ser modificada.

Out.ar(0, //canal de salida, 0 y 1
Pulse.ar(15)*EnvGen.kr(Env.asr(0.01,1,3),gate,doneAction:2)) //salida
}).send(s) //se envia el Synth al servidor designado por default con la letra 's'
)

//El mismo


(
SynthDef("prueba", {|gate=1|
var sen,env;
sen = Pulse.ar(15, 0.2, 0.1);
env = EnvGen.kr(Env.asr(0.01, 1, 3),gate, doneAction:2); Out.ar(0, sen * env)
}).send(s)
)

(
SynthDef("prueba",{arg gate=1;
       var sen,env;
           sen=Pulse.ar(15,0.2,0.1);
	       env=EnvGen.kr(Env.asr(0.01,1,3),gate,doneAction:2);
	Out.ar(0,sen*env)}).send(s)
)

(
{
var sen,env;
sen = Pulse.ar(15, 0.2, 0.5);
env = EnvGen.kr(Env.perc(0, 0.1),Impulse.kr(2)); sen * env
}.play
)
Synth("prueba")


//Una vez creada la estructura del SynthDef es necesario invocarlo para que suene, el SynthDef no suena por si solo. Para esto tenemos dos manera de hacerlo, una de ella es la llamada Object Style.





_________________________

OBEJECT STYLE
_________________________



Synth(nombre, [\argumento1, valor1, ... \argumentoN, valorN], target, addAction)


(
 Synth(      // Utilizamos el método new de la clase Synth

	"prueba", // Un string que especifique el nombre del SynthDef a utilizar para crear el nuevo synth.


	[\gate, 1, \frecuencia, 20], // Un Array opcional que especifique los valores iniciales para los argumentos del SynthDef estos valores son mandados en parejas, el nombre del argumento como symbol y su valor:[\nombre1, valor1, \nombre2, valor2]


	s,  // El target: el grupo donde será creado el nodo de este synth. Si especificamos al servidor como target, nuestro synth será creado en el grupo default del servidor, que es el 1



    \addToTail  // el addAction: especificamos en qué lugar del grupo será creado nuestro synth

	) )



//Para facilitar la invocación del SynthDef podemos utilizar las instrucciones más básicas dejando por default el target y la addAction:
//Ejemplo
a = Synth("prueba")
a = Synth("prueba")
a = Synth("prueba", [\gate, 1]) // Lo prenden
a.set("gate", 0) // Lo apagan

//Como notaran igualando a la variable 'a' un SynthDef que se llama "prueba" para luego modificar sus argumentos por el método .set.

//Los argumentos a los que nos referimos son los que creamos en el SynthDef y esta es la manera en la que cambiamos su valor.
//Hay ciertos componentes de esta estrucutura de los SynthDef que pueden escribirse de otro modo:

(
SynthDef(\prueba, //el tag cambia de comilla a diagonal (cambia de string a symbol)
	{arg gate; // los argumentos pueden enumerarse después de la palabra arg y concluye con punto y coma(;).similar a las variables

	Out.ar(0, //canal de salida, 0 y 1

    Pulse.ar(15)*EnvGen.kr(Env.asr(0.01,1,3),gate,doneAction:2)) //salida

}).send(s) //se envia el synth al servidor designado por default con la letra s
)


a=Synth(\prueba, [\gate, 1]) // las comillas se cambian por diagonales
a.set(\gate, 0) // Lo apagan


(
SynthDef(\mi_primer_synth,{|frecuencia, amplitud|
var sen, env, trig;
trig = Impulse.kr(2);
sen = Saw.ar(frecuencia * [0.988889, 1.011], amplitud); env = EnvGen.kr(Env.perc(0.01, 0.5), trig);
Out.ar(0, sen * env)
}).send(s)
)

a=Synth(\mi_primer_synth)
a=Synth(\mi_primer_synth,[\frecuencia,200,\amplitud,0.3])
a.set(\frecuencia,12)
a.free


//SynthDef con envolvente percusiva más un argumento para el triger

( SynthDef(\mi_primer_synth,{|frecuencia=100,amplitud=0.6,frecuenciatrig=2|
var sen, env, trig;
trig = Impulse.kr(frecuenciatrig);
sen = Saw.ar(frecuencia * [0.988889, 1.011], amplitud); env = EnvGen.kr(Env.perc(0.01, 0.5), trig);
Out.ar(0, sen * env)
}).send(s) )

a = Synth(\mi_primer_synth)
a.set(\frecuenciatrig, 1)
a.set(\frecuenciatrig,5.rrand(10),\frecuencia,101.rrand(1820))
a.free

//SynthDef con envolvente asr

(
SynthDef(\mi_segundo_synth,{|frecuencia=100, amplitud=0.6, gate=1|
var sen,env,trig; sen=Saw.ar(frecuencia*[0.988889,1.011],amplitud); env=EnvGen.kr(Env.asr(3.6,1,4.5),gate,doneAction:2); Out.ar(0,sen*env)
}).send(s)
)
a=Synth(\mi_segundo_synth)
a.set(\frecuencia,10)
a.set(\gate,0)


//En este ejemplo vemos como podemos crear diferentes Synth a partir de un SynthDef.
(
SynthDef(\hola,{|frec=430,amp=0.2,gate=1,trig=10|
var sen,env; sen=SinOsc.ar(frec*[1,1.01],0,amp); env=EnvGen.kr(Env.perc(0,0.1),Impulse.kr(trig)); Out.ar(0,sen*env)
}).send(s)
)

a=Synth(\hola)
a.set(\frec,1700)
a.free

b=Synth(\hola,[\frec,1240])
b.set(\frec,800)
b.free

c=Synth(\hola,[\frec,900])
c.free

//Cuando copilamos la línea de código: a = Synth (\hola) La post nos devuelve: Synth("hola" :1000)
//Esta línea nos dice el nombre del SynthDef utilizado por el Synth y el nodo en donde éste último se encuentra (1000). El número de nodo (nodeID) fue seleccionado automáticamente por la clase Synth, ésta simplemente buscó un número de nodo que estuviese libre.

//Nodo: un objeto con el que se puede establecer comunicación, se encuentra en un árbol de nodos manejado por el servidor de síntesis. El árbol define el orden de ejecución de todos los Synths. Hay dos tipos de nodos: groups y synths. Todos los nodos llevan un número entero por nombre ( nodeID ).



_________________________

EJERCICIO
_________________________


/* 1 */
( SynthDef(\----,{|---,---,---|
var ----,----;
----=SinOsc.ar(----,0,----); ---=EnvGen.kr(Env.perc(0,---),doneAction:2); ---.ar(----,----*----)
}).----(s) )



/* 2 */
( ------(\----,{|---,---,---,----|
var ----,----,----; ---=----.ar(Saw.ar(----,----),-----,0.2); ---=EnvGen.kr(Env.perc(0,----),doneAction:2); Out.ar(----,----*----)
}).----(s)
)























