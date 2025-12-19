% Impulse response of a mass–spring–damper system
% (numerical solution)

clc
clear

%% System parameters
k = 1000;           % Stiffness (N/m)
m = 10;             % Mass (kg)
c = 20;             % Damping coefficient (N·s/m)

ccr = 2*sqrt(k*m);  % Critical damping
eta = c/ccr;        % Damping ratio
wn  = sqrt(k/m);    % Natural frequency (rad/s)

%% Impulse parameters
I  = 5;             % Impulse magnitude (N·s)
v0 = I / m;         % Initial velocity due to impulse (m/s)

%% Initial conditions
x0 = 0;             % Initial displacement (m)
y0 = [x0; v0];      % State vector [x; xdot]

%% Time span
tspan = [0 6];

%% Equation of motion (state-space form)
% m*xdd + c*xd + k*x = 0

odefun = @(t, y_state) [y_state(2); (-c*y_state(2) - k*y_state(1)) / m];

%% Solve ODE
[t, sol] = ode45(odefun, tspan, y0);

x = sol(:,1);       % Displacement response

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

%% Plot impulse response
figure
plot(t, x, 'LineWidth', 1.5)
grid on
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (m)')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
title('Impulse Response')

% Display analytical solution in command window
fprintf('System Parameters:\n');
fprintf('Natural frequency: %.2f rad/s\n', wn);
fprintf('Damping ratio: %.3f\n', eta);
fprintf('Impulse magnitude: %.1f N·s\n', I);
fprintf('\nSolution:\n');
