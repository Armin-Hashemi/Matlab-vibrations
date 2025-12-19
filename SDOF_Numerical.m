% Harmonic response of free and forced vibration in a mass–spring–damper
% system (Numerical solution using ODE45)

clc
clear

%% System parameters
k = 1000;           % Stiffness (N/m)
m = 10;             % Mass (kg)
c = 40;             % Damping coefficient (N.s/m)

ccr = 2*sqrt(k*m);  % Critical damping
eta = c/ccr;        % Damping ratio
wn = sqrt(k/m);     % Natural frequency (rad/s)

%% Excitation parameters
F0 = 40;            % Force amplitude (N)
w  = 2*wn;          % Driving frequency (rad/s)

%% Initial conditions
x0  = 0;            % Initial displacement (m)
v0  = 0;          % Initial velocity (m/s)
y0  = [x0; v0];     % State vector [x; xdot]

%% Time span
tspan = [0 6];

%% Equation of motion (state-space form)
% y(1) = x
% y(2) = xdot

odefun = @(t,y) [y(2);(F0*cos(w*t) - c*y(2) - k*y(1)) / m];

%% Solve ODE
[t, y] = ode45(odefun, tspan, y0);

x = y(:,1);   % Displacement

%% Damping classification
if eta == 1
    text = 'Critically Damped';
elseif eta > 0 && eta < 1
    text = 'Underdamped';
elseif eta > 1
    text = 'Overdamped';
elseif eta == 0
    text = 'Undamped';
end

%% Vibration type
if F0 == 0
    type = 'Free';
else
    type = 'Forced';
end

%% Plot results
figure
plot(t, x, 'LineWidth', 1.5)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (m)')
legend(text)
grid on
title(type + " Vibration")

% Display analytical solution in command window
fprintf('System Parameters:\n');
fprintf('Natural frequency: %.2f rad/s\n', wn);
fprintf('Driving frequency: %.2f rad/s\n', w);
fprintf('Damping ratio: %.3f\n', eta);
fprintf('Force: %.1f N', F0);
fprintf('\nSolution:\n');