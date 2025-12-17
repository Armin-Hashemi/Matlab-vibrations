% Harmonic response of a single-degree-of-freedom (SDOF) system
% subjected to unbalance (rotating mass) excitation

clc
clear

k = 80000;           % Linear stiffness (N/m)
m = 20;              % Lumped mass (kg)
c = 80;              % Viscous damping coefficient (N·s/m)

ccr = 2*sqrt(k*m);   % Critical damping coefficient (N·s/m)
eta = c/ccr;         % Damping ratio (–)
wn = sqrt(k/m);      % Undamped natural circular frequency (rad/s)

% Unbalance excitation parameters
m0 = 0.5;            % Rotating unbalance mass (kg)
e  = 0.15;           % Eccentricity (radius of rotation) (m)
wr = 157;            % Rotational (excitation) frequency (rad/s)

syms x(t)

% Equation of motion for unbalance-forced vibration
eq = m*diff(x,t,2) + c*diff(x,t) + k*x(t) == m0*e*wr^2*sin(wr*t);

vel = diff(x,t);     % Velocity response

% Initial conditions
BC1 = x(0) == 0;     % Initial displacement (m)
BC2 = vel(0) == 0;   % Initial velocity (m/s)
conds = [BC1, BC2];

% Damping classification
if eta == 1
    text = 'Critically damped';
elseif eta > 0 && eta < 1
    text = 'Underdamped';
elseif eta > 1
    text = 'Overdamped';
elseif eta == 0
    text = 'Undamped';
end

% Time-domain response
sol = dsolve(eq, conds);

fplot(sol, [0, 0.5], 'LineWidth', 1.5)  % [0,0.5] is time interval
xlabel('Time, t (s)')
ylabel('Displacement, x(t) (m)')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
grid on
title('Unbalance forced vibration response')

%% Frequency response analysis
clear r
r = linspace(0, 5);  % Frequency ratio r = ω / ω_n

figure(2)
X = (m0*e/m) .* r.^2 ./ sqrt((1 - r.^2).^2 + (2*eta.*r).^2);
plot(r, X, 'LineWidth', 1.5)
grid on
xlabel('Frequency ratio, r = \omega_r / \omega_n')
ylabel('Steady-state displacement amplitude, X (m)')
title('Steady-state displacement response due to unbalance')
legend(sprintf('%s (\\eta = %.3f)', text, eta))

figure(3)
Xm = r.^2 ./ sqrt((1 - r.^2).^2 + (2*eta.*r)).^2;
plot(r, Xm, 'LineWidth', 1.5)
grid on
xlabel('Frequency ratio, r = \omega_r / \omega_n')
ylabel('Dimensionless displacement, X / (m0 e)')
title('Dimensionless steady-state displacement magnitude')
legend(sprintf('%s (\\eta = %.3f)', text, eta))
