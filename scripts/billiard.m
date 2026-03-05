m = 0.16;
R = 0.057/2;
Ic = 2 * m * R^2 / 5;
Dmin = 2 * R; # + 0.001;
k = 1000;
scoeff = -Ic / (m * R^2 + Ic);

t = 0;
r1 = [0, 0];
v1 = [0, 1];
r2 = [-2*R * 3/4, 0.2];
v2 = [0, 0];
o1 = [-v1(2), v1(1), 0] / R;
o2 = [-v2(2), v2(1), 0] / R;

t1 = 5;
dt = 0.001;

%% Plotting
dtplot = t1/360;  % time interval between plots
tplot = dtplot;   % time for next plot
clf
plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 8); hold on
plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 8)
xlabel('{\it x}/m'); ylabel('{\it z}/m')
xlim([-1, 1]); ylim([-1, 1])
axis('equal'); grid on;
pause(0)

while t < t1
  D = norm(r1 - r2);
  if D > Dmin
    F1 = [0, 0];
    F1s = scoeff * F1;
    M1 = [0, 0, 0];
  else
    F1 = - k * (D - Dmin) * (r1 - r2) / D;
    F1s = scoeff * F1;
    M1 = cross([r1, -R], [F1s, 0]) + cross([(r1 + r2) / 2, 0], [F1, 0]);
  end
  F2 = -F1;
  F2s = -F1s;
  M2 = -M1;

  P1 = m * v1;
  P2 = m * v2;

  L1 = cross([r1, 0], [P1, 0]) + Ic * o1;
  L2 = cross([r2, 0], [P2, 0]) + Ic * o2;

  t = t + dt;
  P1 = P1 + (F1 + F1s) * dt;
  P2 = P2 + (F2 + F2s) * dt;
  L1 = L1 + M1 * dt;
  L2 = L2 + M2 * dt;
  r1 = r1 + v1 * dt;
  r2 = r2 + v2 * dt;

  v1 = P1 / m;
  v2 = P2 / m;
  o1 = (L1 - cross([r1, 0], [P1, 0])) / Ic;
  o2 = (L2 - cross([r2, 0], [P2, 0])) / Ic;

    %% plot
  if t > tplot
    hold off;
    plot(r1(1), r1(2), 'o', 'color', '#4477AA', 'markersize', 8); hold on
    plot(r2(1), r2(2), 'o', 'color', '#EE6677', 'markersize', 8)
    xlim([-1, 1]); ylim([-1, 1]); axis('equal');
    pause(0)
    tplot = tplot + dtplot;
  end %@

end

