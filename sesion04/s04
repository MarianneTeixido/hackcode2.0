
//Hackcode. Composición Algorítmica en tiempo real.
//Agosto, 2020
//Festival Sur Aural
//Licencia GNU General Public License v3.0


_______________________________________________________________________________________
_______________________________________________________________________________________


                           CUARTA SESIÓN

                     LECTURA DE VALORES DE CSV

_______________________________________________________________________________________
_______________________________________________________________________________________



p = ProxySpace.push(s.boot);
p.makeTempoClock((120/120));
p.quant = 4;

z = CSVFileReader.read("/home/unyxt/OF/of_v0.10.1_osx_release/apps/myApps/unknownAuthor/bin/data/csv/colorF/1.csv", true, true).postcs;

a = Array.fill(z.size, { arg i; z[i][0].split($ ) });
b = Array.fill(z.size, { arg i; a[i][0] });

~a1R = {Demand.kr(Impulse.kr(~tempo*8), 0, Dseq(b.asInteger,inf))};
~pmosc = {Pan2.ar(PMOsc.ar(~a1R.midicps * 0.25, ~a1R.midicps * 0.15, 1, 0, 0.5))*0.5};

s.scope
~out.free
~out.play
~out = ~pmosc

