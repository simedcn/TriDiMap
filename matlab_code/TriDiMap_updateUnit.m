%% Copyright 2014 MERCIER David
function TriDiMap_updateUnit
%% Function to get units from the GUI and set automatically in the plot
gui = guidata(gcf);

strUnit_Length = get_value_popupmenu(gui.handles.unitLength_GUI, listUnitLength);
strUnit_Property = get_value_popupmenu(gui.handles.unitProp_GUI, listUnitProperty);

set(gui.handles.unit_deltaXindents_GUI, 'string', strUnit_Length);
set(gui.handles.unit_deltaYindents_GUI, 'string', strUnit_Length);
set(gui.handles.unit_colorMin_GUI, 'string', strUnit_Property);
set(gui.handles.unit_colorMax_GUI, 'string', strUnit_Property);
set(gui.handles.unit_x_values_GUI, 'string', strUnit_Length);
set(gui.handles.unit_y_values_GUI, 'string', strUnit_Length);
set(gui.handles.unit_z_values_GUI, 'string', strUnit_Property);
set(gui.handles.unit_transMap_GUI, 'string', strUnit_Property);

gui.config.strUnit_Length = strUnit_Length;
gui.config.strUnit_Property = strUnit_Property;
guidata(gcf, gui);

end