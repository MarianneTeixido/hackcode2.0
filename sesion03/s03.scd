
//Hackcode. Composición Algorítmica en tiempo real.
//Agosto, 2020
//Festival Sur Aural
//Licencia GNU General Public License v3.0


_______________________________________________________________________________________
_______________________________________________________________________________________


                           TERCERA SESIÓN

                            PRIMERA PARTE

                        PROGRAMACIÓN AL VUELO

                            CON NODE PROXY
_______________________________________________________________________________________
_______________________________________________________________________________________



__________________________

       PROXY SPACE
           Y
        JITLib
__________________________

//qué es node proxy

¿Qué es un proxy?


Generalmente, un proxy es un marcador de posición para algo. Un proxy de nodo es un marcador de posición para algo que se reproduce en un servidor que escribe en un número limitado de buses (por ejemplo, un sintetizador o un flujo de eventos). Los objetos NodeProxy se pueden reemplazar y recombinar mientras se reproducen. También se pueden usar para construir una estructura más grande que se usa y se modifica más adelante.

Proxy Space funciona con la librería: JITLib

JITLib, o biblioteca Just in Time, es un sistema que permite a las personas escribir Ugen Graphs (procesamiento de señales en el servidor SC) y reescribirlos en tiempo real. Esto es ideal para codificación en vivo, enseñanza, experimentación y todo tipo de trabajo de composición.

Cuando se accede, ProxySpace devuelve un NodeProxy. Para utilizar la librería JIT, crea un ProxySpace que se convierte en el entorno o espacio de referencia para los sintetizadores que vivirán en él.

Para prender el servidor en el entorno de ProxySpace declaramos:



//________________PRENDER PROXY

p = ProxySpace.push(s.boot); //Inicializa el servidor con NodeProxy


________________

ALGUNOS MÉTODOS DE PROXY
________________


.fadeTime = 3; // fadeTime indica la canditad de segundos para hacer fundido cruzado.

.play; //devuelve un nodo que reproduce sonido en esa variable.

.quant =  4 //cuantiza todos los sintes a un compás de 4/4.

.free //Libera un nodo o grupo de nodos. Libera más no detiene la reproducción.

.stop //Detiene la reproducción de los monitores no de los sintes.

.end //Detiene y libera todos los proxys.

.clear //Borra el proxy de nodo y lo elimina del entorno, esto libera a todos los buses. Si se da un fadeTime, primero se desvanece y luego se borra.


_________________

EJEMPLOS DE CONCATENACIÓN
_________________


p = ProxySpace.push(s.boot);

~out.play;

~out = { SinOsc.ar([400, 407] * 0.9, 0, 0.2) };

~out = { SinOsc.ar([400, 437] * 0.9, 0, 0.2) * LFPulse.kr([1, 1.3]) };

~out = { SinOsc.ar([400, 437] * 0.9, 0, 0.2) * ~x.kr(2) };

~x = { LFPulse.kr([1, 1.3] * MouseX.kr(1, 30, 1)) };

//lag suaviza transformaciones en el tiempo.
~out = { SinOsc.ar([400, 437] * Lag.kr(0.1 + ~x, 0.3), 0, 0.2) * ~x };

p.fadeTime = 5;

~out = { SinOsc.ar([400, 437] * 1.1, 0, 0.2) * ~x.kr(2) };

p.clear(8); //termina y limpia en 8 segundos



_________________

EJEMPLOS SECUENCIAS USANDO DEMAND

_________________


//En este punto les sugiero matar el servidor y recompilar.
p = ProxySpace.push(s.boot); // use ProxySpace as current environment.

~out.play;

//Secuenciación de notas.

s.meter
s.scope

//Acorde

p.quant = 4


~out = ~acorde;

~acorde = { Pan2.ar(SinOsc.ar([60,64,67].midicps,0,0.5))};

//Arpegio, secuencias de notas con Demand.

~out.free

~out = ~arpegio;

~arpegio = { Pan2.ar(SinOsc.ar(~seqArpegio,0,0.5))};

~seqArpegio = { Demand.kr(Impulse.kr(8),0,Dseq([60,64,67].midicps,inf)) }

/*Ejercicio sugerido. Probar con otras formas de onda*/


//Creación de un kick, usando Decay como envolvente y Demand como secuenciador.

~out = ~kick;

~kick = { Pan2.ar(SinOsc.ar(90)*Decay.kr(Demand.kr(Impulse.kr(6),0,Dseq([1,1,1,1],inf))*Impulse.kr(6),0.2))};



//Anidación de demands para controlar la velocidad de los beats.

~out = ~kick;

~kick = { Pan2.ar(SinOsc.ar(90)*Decay.kr(Demand.kr(Impulse.kr(~demaK),0,Dseq([1,1,1,1],inf))*Impulse.kr(~demaK),0.2))};

~demaK = {Demand.kr(Impulse.kr(1),0,Dseq([6,4,2,1],inf))};

~out.free

/*Anidar demands dentro del kick para secuenciar la frecuencia*/



// Secuencia con ruido.

~out.free

(
~out = ~kick + ~hh;

~hh = {WhiteNoise.ar(0.3)*Decay.kr(Demand.kr(Impulse.kr(1),0,Dseq([1,1,1,1],inf))*Impulse.kr(1),0.09)*3};

~kick = { Pan2.ar(SinOsc.ar(90)*Decay.kr(Demand.kr(Impulse.kr(6),0,Dseq([1,1,1,1],inf))*Impulse.kr(6),0.2))};

)

/*A partir de aquí, ¿qué podemos hacer?*/

//Una opción, cuantizar.

p.makeTempoClock(200/120);
p.quant = 4;

~out.free

(
~out = ~kick + ~hh;

~hh = {WhiteNoise.ar(0.3)*Decay.kr(Demand.kr(Impulse.kr(~tempo),0,Dseq([1,1,1,1],inf))*Impulse.kr(~tempo),0.09)*3};

~kick = { Pan2.ar(SinOsc.ar(90)*Decay.kr(Demand.kr(Impulse.kr(~tempo*6),0,Dseq([1,1,1,1],inf))*Impulse.kr(~tempo*6),0.2))};
)

//_____________________________________________
/*
Para compilar un conjunto de expresiones:
1.- Colocar entre paréntesis.
2.- Compilar con CTRL + ENTER

Agrupar expresiones nos puede permitir escribir escenas que se compilan y cuantizan.
*/
//______________________________________________



c = Buffer.read(s, "/home/unyxt/muestras/ua/08monk.wav");

~out = ~buffer
~out.free

~buffer = {Pan2.ar(PlayBuf.ar(2, c, BufRateScale.kr(c)* 1,Impulse.kr(~tempo*(Demand.kr(Impulse.kr(~tempo),0,Dseq([0.5],inf)))), BufFrames.kr(c)*(Demand.kr(Impulse.kr(~tempo),0,Dseq([0.01],inf))),1)).flat * 1};

//Ejercicio, desenrredar el código.



_______________________________________________________________________________________
_______________________________________________________________________________________


                           SEGUNDA SESIÓN

                            SEGUNDA PARTE

                     CONEXIÓN DE PROXY CON MIDI
_______________________________________________________________________________________
_______________________________________________________________________________________

/*Intrucciones
1.- Recompilar y matar el servidor.
2.- PRIMERO conectar el midi conect all
3.- Declarar el bloque de código que mapea cada perilla del dispositivo MIDI
4.- Mover las perillas para conocer el puerto, canal y valor. Respectivamente.
    Los valores declarados en midi van de 0 a 127 o 0 y 127 en el caso de los
    valores booleanos.
5.- Prender el servidor en modo Proxy


*/


MIDIIn.connectAll  //// Inicia un puerto para la conexión con la interfaz midi.


(
//Reconoce los valores del dispositivo MIDI

~noteOff = { arg src, chan, num, vel;    [chan,num,vel / 127].postln; };
~noteOn = { arg src, chan, num, vel;    [chan,num,vel / 127].postln; };
~polytouch = { arg src, chan, num, vel;    [chan,num,vel / 127].postln; };
~control = { arg src, chan, num, val;    [chan,num,val].postln; };
~program = { arg src, chan, prog;        [chan,prog].postln; };
~touch = { arg src, chan, pressure;    [chan,pressure].postln; };
~bend = { arg src, chan, bend;        [chan,bend - 8192].postln; };
~sysex = { arg src, sysex;        sysex.postln; };
~sysrt = { arg src, chan, val;        [chan,val].postln; };
~smpte = { arg src, chan, val;        [chan,val].postln; };
MIDIIn.addFuncTo(\noteOn, ~noteOn);
MIDIIn.addFuncTo(\noteOff, ~noteOff);
MIDIIn.addFuncTo(\polytouch, ~polytouch);
MIDIIn.addFuncTo(\control, ~control);
MIDIIn.addFuncTo(\program, ~program);
MIDIIn.addFuncTo(\touch, ~touch);
MIDIIn.addFuncTo(\bend, ~bend);
MIDIIn.addFuncTo(\sysex, ~sysex);
MIDIIn.addFuncTo(\sysrt, ~sysrt);
MIDIIn.addFuncTo(\smpte, ~smpte);
)

//Servidor
p = ProxySpace.push(s.boot); // use ProxySpace as current environment.
~out.play;

//Muestras
c = Buffer.read(s, "/home/unyxt/muestras/ua/08monk.wav");

s.scope

~out.free

(
~out = ~sonido;
~sonido = {arg note = 60; Pan2.ar(Saw.ar(note.midicps,0.125))};
)

(
a = MIDIFunc.cc({arg ...args; args.postln; ~sonido.set(\note, args.linlin(0,127,52,70))}, 1);
)

(
//Limpiar
a.stop;
)

/*Ejercicio sugerido: agregar más parámetro a MIDI y live codearlos*/
