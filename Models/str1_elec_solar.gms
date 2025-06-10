Sets

t    'number of hours'                       /1*8760/
i    'number of countries'                   /1*26/
n    'number of years'                       /1*27/
j    'number of cost advancement scenarios'  /1*3/
m    'index for parameter inputs'            /1*1/;

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

$call gdxxrw.exe Heat_pump_capital_cost.xlsx par=costhp rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costhp(j,n);
$gdxin Heat_pump_capital_cost.gdx
$load costhp
$gdxin

$call gdxxrw.exe Heat_Electricity_ratio.xlsx par=heratio rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter heratio(m,i);
$gdxin Heat_Electricity_ratio.gdx
$load heratio
$gdxin

$call gdxxrw.exe Battery_capital_cost.xlsx par=costbattery rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costbattery(j,n);
$gdxin Battery_capital_cost.gdx
$load costbattery
$gdxin

$call gdxxrw.exe Battery_operating_cost.xlsx par=opbattery rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter opbattery(j,n);
$gdxin Battery_operating_cost.gdx
$load opbattery
$gdxin

$call gdxxrw.exe Interface_capital_cost.xlsx par=costinterface rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costinterface(j,n);
$gdxin Interface_capital_cost.gdx
$load costinterface
$gdxin

$call gdxxrw.exe Interface_operating_cost.xlsx par=opinterface rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter opinterface(j,n);
$gdxin Interface_operating_cost.gdx
$load opinterface
$gdxin

$call gdxxrw.exe Cap_ratio.xlsx par=cpratio rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter cpratio(m,i);
$gdxin Cap_ratio.gdx
$load cpratio
$gdxin

$call gdxxrw.exe EU_PV_max.xlsx par=pvm rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter pvm(m,i);
$gdxin EU_PV_max.gdx
$load pvm
$gdxin

$call gdxxrw.exe Electricity_price.xlsx par=EPEU rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter EPEU(m,i);
$gdxin Electricity_price.gdx
$load EPEU
$gdxin

$call gdxxrw.exe Rated_capacity.xlsx par=RCP rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter RCP(m,i);
$gdxin Rated_capacity.gdx
$load RCP
$gdxin

$call gdxxrw.exe Natural_gas_price.xlsx par=NPEU rng=sheet1!A1:AB2
*=== Now import data from GDX
Parameter NPEU(m,i);
$gdxin Natural_gas_price.gdx
$load NPEU
$gdxin

Acronym zero

Parameter
radin(t)
ICsolar
sfoc
fr
cr
IChpump
ICbattery
bfoc
ICinterface
ifoc
PVmax
rtc
ec
nc
NY /25/
shpump /0.571/
sbattery /0.571/
sinterface /0.571/
cap /0.1662/
dr /0.03/
hpmax /1000/
COP /3/
bmax /1000/
TOE(j,n,i)
TOH(j,n,i)
PUTt(j,n,i)
PEQ(j,n,i)
PHQ(j,n,i)
PHP(j,n,i)
HPC(j,n,i)
BSC(j,n,i)
BIC(j,n,i)
;

integer variable
nhpump
;

Positive variable
Psolar(t)
Putilized(t)
Pelec(t)
Phpump(t)
Pheat(t)
hpumpop(t)
Psolartotal
Putilizedtotal
Pelectotal
Phpumptotal
Pheattotal
Ctotal
Csolar
Chpump
Cbattery
Cinterface
Cele
bcap
capinterface
SALrecover
SALbattery
SALhpump
SALinterface
OPEXtotal
OPEXsolar
OPEXhpump
OPEXbattery
OPEXinterface
OPEXele
Tcoe
Tcoh
TC
TCeq
Asolar
Putilizedeq
Peleceq
Pheateq
;

Variable
npv
;

Equations
eqPsolar(t)
eqPutilized(t)
eqPbalance(t)
eqPheat(t)
eqPhpump(t)
eqhpumpop(t)
eqPsolartotal
eqPutilizedtotal
eqPelectotal
eqPhpumptotal
eqPheattotal
eqPrelation
eqbcap
eqcapinterface
eqCsolar
eqChpump
eqCbattery
eqCinterface
eqCtotal
eqCele
eqSALhpump
eqSALbattery
eqSALinterface
eqSALrecover
eqOPEXsolar
eqOPEXhpump
eqOPEXbattery
eqOPEXinterface
eqOPEXtotal
eqOPEXele
eqrated
eqTC
eqTcoe
eqTcoh
eqPutilizedeq
eqPeleceq
eqPheateq
eqnpv
;

eqPsolar(t).. Psolar(t) =e= cap*Asolar*radin(t)/1000 ;
eqPutilized(t).. Putilized(t) =l= Psolar(t) ;
eqPbalance(t).. Putilized(t) =e= Pelec(t)+Phpump(t) ;
eqPheat(t).. Pheat(t) =e= Phpump(t)*COP ;
eqPhpump(t).. Phpump(t) =l= hpumpop(t)*hpmax;
eqhpumpop(t).. hpumpop(t) =l= nhpump ;
eqPsolartotal.. Psolartotal =e= NY*sum(t,Psolar(t)) ;
eqPutilizedtotal.. Putilizedtotal =e= NY*sum(t,Putilized(t)) ;
eqPelectotal.. Pelectotal =e= NY*sum(t, Pelec(t));
eqPhpumptotal.. Phpumptotal =e= NY*sum(t, Phpump(t));
eqPheattotal.. Pheattotal =e= NY*sum(t, Pheat(t));
eqPrelation.. Pheattotal =e= Pelectotal*fr ;
eqbcap.. cap*Asolar*PVmax/1000*0.2*4 =e= bcap ;
eqcapinterface.. capinterface =e= cap*Asolar*PVmax/1000*0.2 ;
eqCsolar.. Csolar =e= Asolar*ICsolar ;
eqChpump.. Chpump =e= nhpump*IChpump*2 ;
eqCbattery.. Cbattery =e= bcap*ICbattery*2 ;
eqCinterface.. Cinterface =e= capinterface*ICinterface*2 ;
eqCtotal.. Ctotal =e= Csolar+Chpump+Cbattery+Cinterface ;
eqCele.. Cele =e= Csolar+Cbattery+Cinterface ;
eqSALhpump.. SALhpump =e= nhpump*IChpump*shpump ;
eqSALbattery.. SALbattery =e= bcap*ICbattery*sbattery ;
eqSALinterface.. SALinterface =e= capinterface*ICinterface*sinterface ;
eqSALrecover.. SALrecover =e= (SALhpump+SALbattery+SALinterface)/((1+dr)**NY) ;
eqOPEXsolar.. OPEXsolar =e= sfoc*rtc*1000000*NY ;
eqOPEXhpump.. OPEXhpump =e= 0.05*nhpump*IChpump*NY ;
eqOPEXbattery.. OPEXbattery =e= bcap*bfoc*NY ;
eqOPEXinterface.. OPEXinterface =e= capinterface*ifoc*NY ;
eqOPEXtotal.. OPEXtotal =e= OPEXsolar+OPEXhpump+OPEXbattery+OPEXinterface ;
eqOPEXele.. OPEXele =e= OPEXsolar+OPEXbattery+OPEXinterface ; 
eqrated.. rtc =e= sum(t,Psolar(t))/1000000000/cr ;
eqTC.. TC =e= Ctotal+(OPEXtotal/(NY*dr)*(1-1/(1+dr)**NY))-SALrecover;
eqTcoe.. Tcoe =e= Cele+(OPEXele/(NY*dr)*(1-1/(1+dr)**NY))-(SALbattery+SALinterface)/((1+dr)**NY);
eqTcoh.. Tcoh =e= Chpump+(OPEXhpump/(NY*dr)*(1-1/(1+dr)**NY))-(SALhpump)/((1+dr)**NY);
eqPutilizedeq.. Putilizedeq =e= Putilizedtotal/NY;
eqPeleceq.. Peleceq =e= Pelectotal/NY;
eqPheateq.. Pheateq =e= Pheattotal/NY;
eqnpv.. npv =e= (Peleceq*ec+Pheateq*nc)/dr*(1-1/(1+dr)**NY)-TC ;

model str_elec_solar / all /;

loop (j$(ord(j)<= 3),

loop (n$(ord(n)<= 27),

ICsolar = costsolar(j,n);
sfoc = opsolar(j,n);
IChpump = costhp(j,n);
ICbattery =costbattery(j,n);
bfoc = opbattery(j,n);
ICinterface =costinterface(j,n);
ifoc =opinterface(j,n);

loop (i$(ord(i)<= 26),

radin(t) = radiation(i,t) ;

loop (m$(ord(m)<= 1),
fr = heratio(m,i);
cr = cpratio(m,i);
PVmax = pvm(m,i);
ec = EPEU(m,i);
rtc = RCP(m,i);
nc = NPEU(m,i);
)

solve str_elec_solar using mip maximizing npv ;

TOE(j,n,i)= Tcoe.l;
PUTt(j,n,i)= Putilizedeq.l; 
TOH(j,n,i)= Tcoh.l;
PHP(j,n,i)= Phpumptotal.l;
PEQ(j,n,i)= Peleceq.l;
PHQ(j,n,i)= Pheateq.l;
HPC(j,n,i)= nhpump.l;
BSC(j,n,i)= bcap.l;
BIC(j,n,i)= capinterface.l;

)
)
) ;

TOE(j,n,i)$(NOT TOE(j,n,i)) = zero;
PUTt(j,n,i)$(NOT PUTt(j,n,i)) = zero;
TOH(j,n,i)$(NOT TOH(j,n,i)) = zero;
PHP(j,n,i)$(NOT PHP(j,n,i)) = zero;
PEQ(j,n,i)$(NOT PEQ(j,n,i)) = zero;
PHQ(j,n,i)$(NOT PHQ(j,n,i)) = zero;
HPC(j,n,i)$(NOT HPC(j,n,i)) = zero;
BSC(j,n,i)$(NOT BSC(j,n,i)) = zero;
BIC(j,n,i)$(NOT BIC(j,n,i)) = zero;

display TOE;
display PUTt;
display TOH;
display PHP;
display PEQ;
display PHQ;
display HPC;
display BSC;
display BIC;
