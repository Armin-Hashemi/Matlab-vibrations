%Impulse response of a mass–spring–damper system
%The impulse is modeled as a Dirac delta function at t=0
clc
clear

k=1000;          % Stiffness (N/m)
m=10;            % Mass (kg)
c=20;            % Damping coefficient (N.s/m)
ccr=2*sqrt(k*m); % Critical damping
eta=c/ccr;       % Damping ratio
wn=sqrt(k/m);    % Natural frequency

% Impulse parameters
I = 5;         % Impulse magnitude (N.s) - integral of force over time

syms x(t)
eq = m*diff(x,t,2) + c*diff(x,t) + k*x(t) == 0; % Homogeneous equation
vel = diff(x);

% For an impulse at t=0, the initial conditions are:
BC1 = x(0) == 0;       % Initial displacement (m)
BC2 = vel(0) == I/m;   % Initial velocity from impulse (m/s)
conds = [BC1, BC2];

% Determine damping type
if eta==1
    text='Critically Damped';
elseif eta>0 && eta<1
    text='Underdamped';
elseif eta>1
    text='Overdamped';
elseif eta==0
    text='Undamped';
end

% Solve the differential equation
sol = dsolve(eq, conds);

% Plot the response
fplot(sol, [0, 5], 'LineWidth', 1.5)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (m)')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
grid on
title('Impulse Response')

% Display analytical solution in command window
fprintf('System Parameters:\n');
fprintf('Natural frequency: %.2f rad/s\n', wn);
fprintf('Damping ratio: %.3f\n', eta);
fprintf('Impulse magnitude: %.1f N·s\n', I);
fprintf('\nSolution:\n');
disp(sol);