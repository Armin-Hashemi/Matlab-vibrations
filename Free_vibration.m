clear;
clc;
%% Mass-spring-damper properties with initial conditions
t=linspace(0,2,500); % Time interval is [0,2] seconds
k=200; % Stiffness N/m
m=2;   % Mass kg
c=10;  % Damping coefficient N.s/m
x0=1;  % Initial displacement mm
v0=3;  % Initial velocity     mm/s
%% Calculation
ccr=2*sqrt(k*m);       % Critical damping
eta=c/ccr;             % Damping ratio
wn=sqrt(k/m);          % Undamped natural frequency
wd=wn*sqrt(1-eta^2);   % Damped natural frequency
if eta<1
    A0=sqrt(((wd*x0)^2+(v0+eta*wn*x0)^2))/wd;
    phi1=atan((wd*x0)/(v0+eta*wn*x0));
    y=A0*exp(-eta*wn*t).*sin(wd*t+phi1);  % Displacement
    text='Underdamped';
elseif eta==1
    A1=x0;
    A2=v0*wn*x0;
    y=(A1+A2*t).*exp(-wn*t);
    text='Critically Damped';
elseif eta>1
    A3=(-v0+((-eta+sqrt(eta^2-1))*wn*x0))/(2*wn*sqrt(eta^2-1));
    A4=(v0+((eta+sqrt(eta^2-1))*wn*x0))/(2*wn*sqrt(eta^2-1));
    y=exp(-eta*wn*t).*(A3*exp(-wn*sqrt(eta^2-1)*t)+A4*exp(wn*sqrt(eta^2-1)*t));
    text='Overdamped';
end
plot(t, y, 'LineWidth', 2)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (mm)')
legend(text)
grid on