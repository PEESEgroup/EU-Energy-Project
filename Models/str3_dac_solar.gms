Sets

t    'number of hours'                       /1*8760/
i    'number of countries'                   /1*26/
n    'number of years'                       /1*27/
j    'number of cost advancement scenarios'  /1*3/
m    'index for port distribution'           /1*1/;

$call gdxxrw.exe EU_rad.xlsx par=radiation rng=sheet1!A1:LXY28 
*=== Now import data from GDX
Parameter radiation(i,t);
$gdxin EU_rad.gdx
$load radiation
$gdxin

$call gdxxrw.exe Solar_capital_cost.xlsx par=costsolar rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costsolar(j,n);
$gdxin Solar_capital_cost.gdx
$load costsolar
$gdxin

$call gdxxrw.exe Solar_operating_cost.xlsx par=opsolar rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter opsolar(j,n);
$gdxin Solar_operating_cost.gdx
$load opsolar
$gdxin

$call gdxxrw.exe DAC_cost.xlsx par=costDAC rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costDAC(j,n);
$gdxin DAC_cost.gdx
$load costDAC
$gdxin

$call gdxxrw.exe Cap_ratio.xlsx par=cpratio rng=sheet1!A1:AA2
*=== Now import data from GDX
Parameter cpratio(m,i);
$gdxin Cap_ratio.gdx
$load cpratio
$gdxin

$call gdxxrw.exe Transport_cost.xlsx par=OPT rng=sheet1!A1:AA2
*=== Now import data from GDX
Parameter OPT(m,i);
$gdxin Transport_cost.gdx
$load OPT
$gdxin

$call gdxxrw.exe Heat_pump_capital_cost.xlsx par=costhp rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costhp(j,n);
$gdxin Heat_pump_capital_cost.gdx
$load costhp
$gdxin

Acronym zero

Parameter
radin(t)
ICsolar
sfoc
ICdac
cr
IChpump
optransport
NY /25/
cap /0.1662/
dacmax /11400/
df /3.4/
daceff/1.72/
hpmax /1000/
COP /3/
shpump /0.571/
co2sp /0.107/
dr /0.1/
opstorage /0.01075/
Tcequivalent(j,n,i)
Carbonequivalent(j,n,i)
DACequivalent(j,n,i)
HPequivalent(j,n,i)
;

integer variable
ndac
nhpump
;

Positive variable
Psolar(t)
Putilized(t)
Pele(t)
Phpump(t)
Pheat(t)
hpumpop(t)
carboncap(t)
carbontotal
Ctotal
Csolar
Cdac
Chpump
SALrecover
OPEXtotal
OPEXsolar
OPEXdac
OPEXhpump
OPEXtransport
OPEXstorage
ratedcapacity
TC
Asolar
;

Variable
npv
;

Equations
eqPsolar(t)
eqPutilized(t)
eqPdistribution(t)
eqPheat(t)
eqPhpump(t)
eqhpumpop(t)
eqPrelation(t)
eqcarboncaptured(t)
eqcarbontotal
eqdacmax(t)
eqCsolar
eqChpump
eqCdac
eqCtotal
eqSALrecover
eqrated1
eqrated2
eqOPEXsolar
eqOPEXdac
eqOPEXhpump
eqOPEXtransport
eqOPEXstorage
eqOPEXtotal
eqTC
eqnpv
;

eqPsolar(t).. Psolar(t) =e= cap*Asolar*radin(t)/1000 ;
eqPutilized(t).. Putilized(t) =e= Psolar(t) ;
eqPdistribution(t).. Putilized(t) =e= Pele(t)+Phpump(t) ;
eqPheat(t).. Pheat(t) =e= Phpump(t)*COP ;
eqPhpump(t).. Phpump(t) =l= hpumpop(t)*hpmax;
eqhpumpop(t).. hpumpop(t) =l= nhpump ;
eqPrelation(t).. Pheat(t) =e= Pele(t)*df ;
eqcarboncaptured(t).. carboncap(t) =e= Pele(t)*daceff ;
eqcarbontotal.. carbontotal =e= sum(t,carboncap(t));
eqdacmax(t).. carboncap(t) =l= ndac*dacmax ;
eqCsolar.. Csolar =e= Asolar*ICsolar ; 
eqChpump.. Chpump =e= nhpump*IChpump*2 ;
eqCdac..   Cdac =e= carbontotal*NY*ICdac ;
eqCtotal.. Ctotal =e= Csolar+Cdac+Chpump ;
eqSALrecover.. SALrecover =e= nhpump*IChpump*shpump/((1+dr)**NY) ;
eqrated1.. ratedcapacity =e= sum(t,Psolar(t))/1000000000/cr ;
eqrated2.. ratedcapacity =e= 0.0226 ;
eqOPEXsolar.. OPEXsolar =e= sfoc*ratedcapacity*1000000*NY ;
eqOPEXdac..   OPEXdac =e= 0.04*Cdac*NY ;
eqOPEXhpump.. OPEXhpump =e= 0.05*nhpump*IChpump*NY ;
eqOPEXtransport.. OPEXtransport =e= optransport*carbontotal*NY ;
eqOPEXstorage.. OPEXstorage =e= opstorage*carbontotal*NY ;
eqOPEXtotal.. OPEXtotal =e= OPEXsolar+OPEXdac+OPEXtransport+OPEXstorage+OPEXhpump ;
eqTC.. TC =e= Ctotal+(OPEXtotal/(NY*dr)*(1-1/(1+dr)**NY))-SALrecover;
eqnpv.. npv =e= co2sp*carbontotal/dr*(1-1/(1+dr)**NY)-TC ;

model str_dac_solar / all /;

loop (j$(ord(j)= 1),

loop (n$(ord(n)<= 1),

ICsolar = costsolar(j,n);
sfoc = opsolar(j,n);
ICdac = costDAC(j,n);
IChpump = costhp(j,n);

loop (i$(ord(i)= 26),

radin(t) = radiation(i,t) ;

loop (m$(ord(m)<= 1),
cr = cpratio(m,i);
optransport = OPT(m,i);
)

solve str_dac_solar using mip maximizing npv ;

Tcequivalent(j,n,i) = TC.l;
Carbonequivalent(j,n,i) = carbontotal.l ; 
DACequivalent(j,n,i) = ndac.l ;
HPequivalent(j,n,i) = nhpump.l ;

)
)
) ;

Tcequivalent(j,n,i)$(NOT Tcequivalent(j,n,i)) = zero;
Carbonequivalent(j,n,i)$(NOT Carbonequivalent(j,n,i)) = zero;
DACequivalent(j,n,i)$(NOT DACequivalent(j,n,i)) = zero;
HPequivalent(j,n,i)$(NOT HPequivalent(j,n,i)) = zero;

display Tcequivalent;
display Carbonequivalent;
display DACequivalent;
display HPequivalent;




