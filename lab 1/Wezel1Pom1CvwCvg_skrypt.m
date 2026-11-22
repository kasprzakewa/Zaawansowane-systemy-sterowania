
clear all; close all;
%demo dla pomieszczenia z grzejnikem wodnym
model='Wezel1Pom1CvwCvg';
aparam1;
%wartoœci nominalne
%parametry instalacji w warunkach obliczeniowych
QgN = 2000;         %[W] (zapotrezbowanie budynku)
TzewN = -20;		%[C] (temperatura na zewn¹trz)
TwewN = 20;			%[C] (zadana temperatura wewnetrzna)
TgzN = 90;              %[C]  
TgpN = 70;              %[C] 
TwzN = 130;		%[C]  
TwpN = 110;		%[C] 

%parametry statyczne
FgN = QgN/(cpw*(TgzN-TgpN));	%[kg/s]
Kcg = QgN/(TgpN-TwewN);			  %[W/K]
Kcw = QgN/(TwewN-TzewN);	    %[W/K]
FwN = QgN / (TwzN - TwpN) / cpw;
Kco = QgN / (TwpN - TgzN);          %[W/K]
atz_c = (TwzN-TzewN)/(TwewN-TzewN); btz_c = (TwzN-TwewN)/(TwewN-TzewN);
%parametry "dynamiczne" - aparam1
%==========================
%warunki pocz¹tkowe
SPc0 = TwewN;
Tzew0 = TzewN+0;	%+1
Twz0 = atz_c*SPc0 - btz_c*Tzew0;
Fg0 = FgN;
Fw0 = FwN;
Qt0 = 0;
%stan równowagi
a = cpw*Fg0; b = cpw*Fw0;

%do równañ stanu i r.statycznych X=Tgp, Twew
%u=[Twz; Tzew];	x=[Twew; Tgp; Tgz; Twp], y=x
A = [(-Kcg-Kcw)/Cvws, Kcg/Cvws,                 0,                                0;...
      Kcg/Cvg,                (-cpw*Fg0-Kcg)/Cvg, cpw*Fg0/Cvg,            0;...
	  0,                           cpw*Fg0/Cvo,             (-cpw*Fg0-Kco)/Cvo, Kco/Cvo; ...
  	  0,                           0,                                Kco/Cvo,                     (-cpw*Fw0-Kco)/Cvo; ];
B = [0, Kcw/Cvws; 
       0, 0;  
       0, 0;         
       cpw*Fw0/Cvo,        0];
C = [1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1]; D=[0,0;0,0;0,0;0,0];

u0 = [Twz0; Tzew0];					%u=[Tgz; Tz],
x0 = -A^(-1)*B*u0;
Twew0 = x0(1);Tgp0 = x0(2);Tgz0 = x0(3);Twp0 = x0(4);			%x=[Tw; Tgp; Tgz; Twp], 
%==========================
%zak³ócenie
dSPc = 0;
dTzew = 0;
dFg = 0*FgN;
dFw = 0.1*FwN;

dQt = 0;
%==========================
%symulacja
czas =4000;	czas_skok = 500;
%opcje = simget(model); %opcje = simset('MaxStep', tmax, 'RelTol',terr);
[t] = sim(model, czas); 
figure(1); hold on; grid on; title('Twew'); plot(t,aTwew,'m'),
figure(2); hold on; grid on; title('Twz, Twp'); plot(t,aTwz,'r'), plot(t,aTwp,'b'), legend('Twz', 'Twp');

