filename = 'blah';
fig = gcf;
set(gca, 'FontSize', 33);print(fig, ['../images' filename '.pdf'], '-dpdf');
%% Plot total y-momentum vs t
figure();
plot(tSave,PyaSave+PybSave,'-','Color',cols(3,:));
axis('tight'); xlabel('{\it t}/s'); ylabel('{\it P_y}/(Ns)');
%% Plot total z-momentum vs t
figure();
plot(tSave,PzaSave+PzbSave,'-','Color',cols(3,:));
axis('tight'); xlabel('{\it t}/s'); ylabel('{\it P_z}/(Ns)'); %@

