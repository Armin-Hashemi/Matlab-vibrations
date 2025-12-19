% Harmonic response of a mass–spring–damper system
% under UNBALANCED (rotating mass) excitation (numerical solution)

clc
clear

%% System parameters
k = 40000;          % Stiffness (N/m)
m = 1007;           % Mass (kg)
c = 2000;           % Damping coefficient (N.s/m)

ccr = 2*sqrt(k*m);  % Critical damping
eta = c/ccr;        % Damping ratio
wn  = sqrt(k/m);    % Natural frequency (rad/s)

%% Unbalance excitation parameters
m0 = 0.5;             % Unbalanced mass (kg)
e  = 0.15;          % Eccentricity (m)
wr = 15;          % Rotational speed (rad/s)

%% Initial conditions
x0 = 0;             % Initial displacement (m)
v0 = 0;             % Initial velocity (m/s)
y0 = [x0; v0];      % State vector [x; xdot]

%% Time span
tspan = [0 6];

%% Equation of motion (state-space form)
% m*xdd + c*xd + k*x = m0*e*wr^2*sin(wr*t)

odefun = @(t,y_state) [
 y_state(2); ( m0*e*wr^2*sin(wr*t) - c*y_state(2) - k*y_state(1) ) / m];

%% Solve ODE
[t, sol] = ode45(odefun, tspan, y0);

x = sol(:,1);   % Displacement of mass

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
title("Unbalanced Excitation")

%% Frequency response analysis
clear r
r = linspace(0, 5, 200);  % Frequency ratio r = ω / ω_n

figure(2)
X = (m0*e/m) .* r.^2 ./ sqrt((1 - r.^2).^2 + (2*eta.*r).^2);
plot(r, X, 'LineWidth', 1.5)
grid on
xlabel('Frequency ratio, r = \omega_r / \omega_n')
ylabel('Steady-state displacement amplitude, X (m)')
title('Steady-state displacement')
legend(sprintf('%s (\\eta = %.3f)', text, eta))

figure(3)
Xm = r.^2 ./ sqrt((1 - r.^2).^2 + (2*eta.*r)).^2;
plot(r, Xm, 'LineWidth', 1.5)
grid on
xlabel('Frequency ratio, r = \omega_r / \omega_n')
ylabel('Dimensionless displacement, (m X) / (m0 e)')
title('Dimensionless steady-state displacement')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
