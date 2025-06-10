Sets

t    'number of hours'                       /1*8760/
i    'number of countries'                   /1*26/
n    'number of years'                       /1*27/
j    'number of cost advancement scenarios'  /1*3/
m    'index for port distribution'           /1*1/;

$call gdxxrw.exe EU_speed.xlsx par=speed rng=sheet1!A1:LXY28 
*=== Now import data from GDX
Parameter speed(i,t);
$gdxin EU_speed.gdx
$load speed
$gdxin

$call gdxxrw.exe Wind_capital_cost.xlsx par=costwind rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costwind(j,n);
$gdxin Wind_capital_cost.gdx
$load costwind
$gdxin

$call gdxxrw.exe Wind_operating_cost.xlsx par=opwind rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter opwind(j,n);
$gdxin Wind_operating_cost.gdx
$load opwind
$gdxin

$call gdxxrw.exe DAC_cost.xlsx par=costDAC rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costDAC(j,n);
$gdxin DAC_cost.gdx
$load costDAC
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
wspeed(t)
Pwind(t)
ICwind
wfoc
Ichpump
ICdac
optransport 
NY /25/
Pratedwind /22.6/
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
Putilized(t)
Pele(t)
Phpump(t)
Pheat(t)
hpumpop(t)
carboncap(t)
carbontotal
Pwindtotal
Putilizedtotal
Pdactotal
Ctotal
Cwind
Cdac
Chpump
SALrecover
OPEXtotal
OPEXwind
OPEXdac
OPEXhpump
OPEXtransport
OPEXstorage
TC
;

Variable
npv
;

Equations
eqPutilized(t)
eqPdistribution(t)
eqPheat(t)
eqPhpump(t)
eqhpumpop(t)
eqPrelation(t)
eqcarboncaptured(t)
eqcarbontotal
eqdacmax
eqCwind
eqChpump
eqCdac
eqCtotal
eqSALrecover
eqOPEXwind
eqOPEXdac
eqOPEXhpump
eqOPEXtransport
eqOPEXstorage
eqOPEXtotal
eqTC
eqnpv
;

eqPutilized(t).. Putilized(t) =e= Pwind(t) ;
eqPdistribution(t).. Putilized(t) =e= Pele(t)+Phpump(t) ;
eqPheat(t).. Pheat(t) =e= Phpump(t)*COP ;
eqPhpump(t).. Phpump(t) =l= hpumpop(t)*hpmax;
eqhpumpop(t).. hpumpop(t) =l= nhpump ;
eqPrelation(t).. Pheat(t) =e= Pele(t)*df ;
eqcarboncaptured(t).. carboncap(t) =e= Pele(t)*daceff ;
eqcarbontotal.. carbontotal =e= sum(t,carboncap(t)) ;
eqdacmax(t).. carboncap(t) =l= ndac*dacmax ;
eqCwind.. Cwind =e= Pratedwind*ICwind ;
eqChpump.. Chpump =e= nhpump*IChpump*2 ;
eqCdac..   Cdac =e= carbontotal*NY*ICdac ;
eqCtotal.. Ctotal =e= Cwind+Cdac+Chpump ;
eqSALrecover.. SALrecover =e= nhpump*IChpump*shpump/((1+dr)**NY) ;
eqOPEXwind.. OPEXwind =e= wfoc*Pratedwind*NY ;
eqOPEXdac..   OPEXdac =e= 0.04*Cdac*NY ;
eqOPEXhpump.. OPEXhpump =e= 0.05*nhpump*IChpump*NY ;
eqOPEXtransport.. OPEXtransport =e= 0.005579981*carbontotal*NY ;
eqOPEXstorage.. OPEXstorage =e= opstorage*carbontotal*NY ;
eqOPEXtotal.. OPEXtotal =e= OPEXwind+OPEXdac+OPEXtransport+OPEXstorage+OPEXhpump ;
eqTC.. TC =e= Ctotal+(OPEXtotal/(NY*dr)*(1-1/(1+dr)**NY))-SALrecover;
eqnpv.. npv =e= co2sp*carbontotal/dr*(1-1/(1+dr)**NY)-TC ;

model str_dac_wind / all /;

loop (j$(ord(j)<= 3),

loop (n$(ord(n)<= 27),

ICwind = costwind(j,n);
wfoc = opwind(j,n);
ICdac = costDAC(j,n);
IChpump = costhp(j,n);

loop (i$(ord(i)<= 26),

wspeed(t) = speed(i,t) ;
Pwind(t) = Pratedwind*1000*wspeed(t) ;

loop (m$(ord(m)<= 1),
optransport = OPT(m,i);
)

solve str_dac_wind using mip maximizing npv ;

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




