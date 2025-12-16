%Harmonic response of a base-excited mass–spring–damper system.
%You only need to modify the input parameters, and the code will
%automatically compute the time response x(t)x(t)x(t), force transmissibility (F/kY)
%and displacement transmissibility (X/Y).
clc
clear
k=40000;           % Stiffness (N/m)
m=1007;            % Mass (kg)
c=2000;            % Damping coefficient (N.s/m)
ccr=2*sqrt(k*m);   % Critical damping coefficient
eta=c/ccr;         % Damping ratio
wn=sqrt(k/m);      % Natural frequency (rad/s)

% Excitation parameters
Y=0.01;            % % Road (bump) displacement amplitude (m)
L= 6;              % Lengh of a period of the road
v=20/3.6;          %  % Vehicle speed (m/s)
wb =2*3.1416*v/L;  % % Base excitation frequency (rad/s)

syms x(t) y(t)
y(t) = Y*sin(wb*t);
eq= m*diff(x,t,2) + c*(diff(x,t) - diff(y,t)) + k*(x - y) == 0;
vel = diff(x);
BC1=x(0)==0;        % Initial displacement (m)
BC2=vel(0)==0;      % Initial velocity (m/s)
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
sol=dsolve(eq,conds);
fplot(sol, [0, 10], 'LineWidth', 1.5)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (mm)')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
grid on
title(" Base Excitation Vibration")
%% Displacement transmissibility
clear r
r=linspace(0,5,200);   % Frequency ratio
figure(2)
XY=sqrt((1+(2*eta*r).^2)./((1-r.^2).^2+(2*eta.*r).^2));
plot(r,XY, 'LineWidth', 1.5)
grid on
xlabel('r')
ylabel('X/Y')
title('Transmissibility ratio')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
%% Force transmissibility
clear r
r=linspace(0.1,5,200);  % Frequency ratio
figure(3)
FT=r.^2.*sqrt((1+(2*eta*r).^2)./((1-r.^2).^2+(2*eta.*r).^2));
plot(r,FT, 'LineWidth', 1.5)
grid on
xlabel('r')
ylabel('Ft/KY')
title('Force transmissibility ratio')
legend(sprintf('%s (\\eta = %.3f)', text, eta))