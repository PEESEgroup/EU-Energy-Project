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

$call gdxxrw.exe Electrolyzer_cost.xlsx par=costelectrolyzer rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter costelectrolyzer(j,n);
$gdxin Electrolyzer_cost.gdx
$load costelectrolyzer
$gdxin

$call gdxxrw.exe Electrolyzer_efficiency.xlsx par=effelectrolyzer rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter effelectrolyzer(j,n);
$gdxin Electrolyzer_efficiency.gdx
$load effelectrolyzer
$gdxin

$call gdxxrw.exe Cap_ratio.xlsx par=cpratio rng=sheet1!A1:AA2
*=== Now import data from GDX
Parameter cpratio(m,i);
$gdxin Cap_ratio.gdx
$load cpratio
$gdxin

$call gdxxrw.exe Capital_cost_repurposed_length.xlsx par=capRL rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter capRL(j,n);
$gdxin Capital_cost_repurposed_length.gdx
$load capRL
$gdxin

$call gdxxrw.exe Operating_cost_repurposed_length.xlsx par=opexRL rng=sheet1!A1:AB4
*=== Now import data from GDX
Parameter opexRL(j,n);
$gdxin Operating_cost_repurposed_length.gdx
$load opexRL
$gdxin

$call gdxxrw.exe Hydrogen_repurposed_length.xlsx par=rlength rng=sheet1!A1:AA2
*=== Now import data from GDX
Parameter rlength(m,i);
$gdxin Hydrogen_repurposed_length.gdx
$load rlength
$gdxin

Acronym zero

Parameter
radin(t)
ICsolar
sfoc
Icele
effele
cr
crl
oprl  
rl 
NY /25/
lhv /33.33/
h2sp /7.59/
cap /0.1662/
elemax /1000/
dr /0.1/
ccrl /0.15/
ccnl /2.2/
spipe /0.032/
Tcequivalent(j,n,i)
Hydrogenequivalent(j,n,i)
ratedequivalent(j,n,i)
Elecequivalent(j,n,i)
Pipeequivalent(j,n,i)
;

integer variable
nele
;

Positive variable
Psolar(t)
Putilized(t)
Pele(t)
h2(t)
eleop(t)
hydrogentotal
pipecap
Ctotal
Csolar
Cele
Ctransport
lcoh
SALrecover
OPEXtotal
OPEXsolar
OPEXele
OPEXtransport
ratedcapacity
Asolar
TC
heq
TCeq
Putilizedeq
;

Variable
npv
;

Equations
eqPsolar(t)
eqPutilized(t)
eqPele(t)
eqPele2(t)
eqeleop(t)
eqh2(t)
eqhydrogentotal
eqpipecap(t)
eqnele1
eqnele2
eqCsolar
eqCele
eqCtransport
eqCtotal
eqSALrecover
eqOPEXsolar
eqOPEXele
eqOPEXtransport
eqOPEXtotal
eqrated
eqTC
eqnpv
;

eqPsolar(t).. Psolar(t) =e= cap*Asolar*radin(t)/1000 ;
eqPutilized(t).. Putilized(t) =l= Psolar(t) ;
eqPele(t).. Pele(t) =e= Putilized(t) ;
eqPele2(t).. Pele(t) =e= eleop(t)*elemax ;
eqeleop(t).. eleop(t) =l= nele ;
eqh2(t).. h2(t) =e= (Pele(t)*effele)/lhv ;
eqnele1.. nele =l= 10 ;
eqnele2.. nele =g= 5 ;
eqhydrogentotal.. hydrogentotal =e= sum(t, h2(t)) ;
eqpipecap(t).. pipecap =g= h2(t)*lhv ;  
eqCsolar.. Csolar =e= Asolar*ICsolar ; 
eqCele.. Cele =e= nele*ICele ;
eqCtransport.. Ctransport =e= pipecap*crl*rl ;  
eqCtotal.. Ctotal =e= Csolar+Cele+Ctransport ;
eqSALrecover.. SALrecover =e= Ctransport*spipe/((1+dr)**NY) ;
eqOPEXsolar.. OPEXsolar =e= sfoc*ratedcapacity*1000000*NY ;
eqOPEXele.. OPEXele =e= 0.03*nele*ICele*NY ;
eqOPEXtransport.. OPEXtransport =e= Ctransport*oprl*NY ;
eqOPEXtotal.. OPEXtotal =e= OPEXsolar+OPEXele+OPEXtransport ;
eqrated.. ratedcapacity =e= sum(t,Psolar(t))/1000000000/cr ;
eqTC.. TC =e= Ctotal+(OPEXtotal/(NY*dr)*(1-1/(1+dr)**NY))-SALrecover;
eqnpv.. npv =e= h2sp*hydrogentotal/dr*(1-1/(1+dr)**NY)-TC ;

model str_hyd_solar / all /;

loop (j$(ord(j)<= 3),

loop (n$(ord(n)<= 27),

ICsolar = costsolar(j,n);
sfoc = opsolar(j,n);
ICele = costelectrolyzer(j,n);
effele = effelectrolyzer(j,n);
crl = capRL(j,n);
oprl = opexRL(j,n);

loop (i$(ord(i)<= 26),

radin(t) = radiation(i,t) ;

loop (m$(ord(m)<= 1),
cr = cpratio(m,i);
rl = rlength(m,i);
)

solve str_hyd_solar using mip maximizing npv ;

Tcequivalent(j,n,i) = TC.l;
Hydrogenequivalent(j,n,i) = hydrogentotal.l ; 
ratedequivalent(j,n,i) = ratedcapacity.l ;
Elecequivalent(j,n,i) = nele.l ;
Pipeequivalent(j,n,i) = pipecap.l ;

)
)
) ;

Tcequivalent(j,n,i)$(NOT Tcequivalent(j,n,i)) = zero;
Hydrogenequivalent(j,n,i)$(NOT Hydrogenequivalent(j,n,i)) = zero;
ratedequivalent(j,n,i)$(NOT ratedequivalent(j,n,i)) = zero;
Elecequivalent(j,n,i)$(NOT Elecequivalent(j,n,i)) = zero;
Pipeequivalent(j,n,i)$(NOT Pipeequivalent(j,n,i)) = zero;

display Tcequivalent;
display Hydrogenequivalent;
display ratedequivalent;
display Elecequivalent ;
display Pipeequivalent ;





