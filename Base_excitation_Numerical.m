% Harmonic response of a mass–spring–damper system
% under BASE EXCITATION (numerical solution)

clc
clear

%% System parameters
k = 40000;          % Stiffness (N/m)
m = 1007;           % Mass (kg)
c = 2000;           % Damping coefficient (N.s/m)

ccr = 2*sqrt(k*m);  % Critical damping
eta = c/ccr;        % Damping ratio
wn = sqrt(k/m);     % Natural frequency (rad/s)

%% Base excitation parameters
L = 6;              % Lengh of a period of the road
Y0 = 0.01;          % Base displacement amplitude (m)
v = 20/3.6;         % Vehicle speed (m/s)
wb = 2*3.1416*v/L;  % Excitation frequency (rad/s)

%% Initial conditions
x0 = 0;             % Initial absolute displacement (m)
v0 = 0;             % Initial absolute velocity (m/s)
y0 = [x0; v0];      % State vector [x; xdot]

%% Time span
tspan = [0 6];

%% Base motion and its derivative
y      = @(t) Y0*sin(wb*t);
ydot   = @(t) Y0*wb*cos(wb*t);

%% Equation of motion (state-space form)
% m*xdd + c*(xd - yd) + k*(x - y) = 0

odefun = @(t,y_state) [y_state(2); (-c*(y_state(2) - ydot(t))-k*(y_state(1) - y(t))) / m];

%% Solve ODE
[t, sol] = ode45(odefun, tspan, y0);

x = sol(:,1);   % Absolute displacement of mass

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

%% Plot results
figure
plot(t, x, 'LineWidth', 1.5)
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (m)')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
grid on
title("Base Excitation Response")

%% Displacement transmissibility
clear r
r = linspace(0, 5, 200);        % Frequency ratio

figure(2)
XY = sqrt( (1 + (2*eta*r).^2) ./ ...
          ((1 - r.^2).^2 + (2*eta*r).^2) );

plot(r, XY, 'LineWidth', 1.5)
grid on
xlabel('r')
ylabel('X / Y')
title('Transmissibility Ratio')
legend(sprintf('%s (\\eta = %.3f)', text, eta))

%% Force transmissibility
clear r
r = linspace(0.1, 5, 200);      % Frequency ratio
figure(3)
FT = r.^2 .* sqrt( (1 + (2*eta*r).^2) ./ ...
                  ((1 - r.^2).^2 + (2*eta*r).^2) );

plot(r, FT, 'LineWidth', 1.5)
grid on
xlabel('r')
ylabel('F_t / (kY)')
title('Force Transmissibility Ratio')
legend(sprintf('%s (\\eta = %.3f)', text, eta))

% Display analytical solution in command window
fprintf('System Parameters:\n');
fprintf('Natural frequency: %.2f rad/s\n', wn);
fprintf('Damping ratio: %.3f\n', eta);
fprintf('\nSolution:\n');