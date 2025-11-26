%Harmonic response of free and forced vibration in a mass–spring–damper
%system. This code includes all types of harmonic vibration, and you only
% need to change the values.
clc
clear
k=1000;            % Stiffness N/m
m=10;              % Mass kg
c=40;              % Damping coefficient N.s/m
ccr=2*sqrt(k*m);   % Critical damping
eta=c/ccr;         % Damping ratio
wn=sqrt(k/m);      % Natural frequency

% Excitation parameters
F0 = 40;      % Force amplitude N
w = 2*wn;     % Driving frequency rad/s

syms x(t)
eq=m*diff(x,t,2)+c*diff(x,t)+k*x(t)==F0*cos(w*t);
vel = diff(x);
BC1=x(0)==0;        % Initial displacement m
BC2=vel(0)==0.2;    % Initial velocity     m/s
conds=[BC1,BC2];
if eta==1
    text='Critically Damped';
elseif eta>0 && eta<1
    text='Underdamped';
elseif eta>1
    text='Overdamped';
elseif eta==0
    text='Undamped';
end
if F0==0
    type='Free';
else
    type='Forced';
end
sol=dsolve(eq,conds);
fplot(sol, [0, 6], 'LineWidth', 1.5)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (mm)')
legend(text)
grid on
title(type+" Vibration")