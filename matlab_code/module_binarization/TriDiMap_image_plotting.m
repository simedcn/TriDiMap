%% Copyright 2014 MERCIER David
function TriDiMap_image_plotting
%% Function to plot a microscopical image
gui = guidata(gcf);
cMap = gui.config.colorMap;
flagFlipCM = get(gui.handles.cb_flipColormap_GUI, 'Value');

gui.handles.hAxis1 = imagesc(flipud(gui.image.image2use), ...
    'XData',gui.data.xData_interp,'YData',gui.data.yData_interp);
axisMap(cMap, 'Binarized microscopical image', ...
    gui.config.FontSizeVal, ...
    (gui.config.N_XStep_default-1)*gui.config.XStep_default, ...
    (gui.config.N_YStep_default-1)*gui.config.YStep_default,...
    gui.config.flipColor, gui.config.strUnit_Length);
axis equal;
axis tight;
hold on;
if get(gui.handles.cb_legend_GUI, 'Value')
    gui.handles.hLeg1 = legendMap(2, cMap, 'EastOutside', ...
        {'Soft phase','Stiff/Hard phase'}, 12, flagFlipCM, [0.87 0.70]);
else
    try
        delete(gui.handles.hLeg1)
        legend('hide');
    catch
    end
end

guidata(gcf, gui);

end