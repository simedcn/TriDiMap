%% Copyright 2014 MERCIER David
function handles = TriDiMap_setGUI(module)
%% Definition of the GUI and buttons
g = guidata(gcf);
handles = g.handles;

%% Title of the GUI
handles.title_GUI_1 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.96 0.6 0.04],...
    'String', 'Mapping of mechanical properties from (nano)indentation experiments.',...
    'FontWeight', 'bold',...
    'FontSize', 12,...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red');

handles.title_GUI_2 = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.31 0.93 0.6 0.03],...
    'String', strcat('Version_', ...
    g.config.version_toolbox, ' - Copyright 2014 MERCIER David'),...
    'FontSize', 10);

set([handles.title_GUI_1, handles.title_GUI_2], ...
    'FontWeight', 'bold',...
    'HorizontalAlignment', 'center',...
    'ForegroundColor', 'red')

%% Date / Time
handles.date_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'String', datestr(datenum(clock),'mmm.dd,yyyy HH:MM'),...
    'Position', [0.92 0.975 0.075 0.02]);

%% Buttons to set type of files
handles.pm_set_file = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.02 0.95 0.08 0.04],...
    'String', {'Agilent MTS';'Hysitron';'ASMEC'},...
    'Value', 1,...
    'Callback', '');

%% Units
% Unit definition for the X and Y size
handles.title_unitLength_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.11 0.97 0.04 0.02],...
    'String', 'Length:',...
    'HorizontalAlignment', 'left');

handles.unitLength_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.15 0.97 0.05 0.02],...
    'String', listUnitLength,...
    'Value', 2,...
    'Callback', 'TriDiMap_runPlot');

% Unit definition for the property
handles.title_unitProp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.21 0.97 0.04 0.02],...
    'String', 'Property:',...
    'HorizontalAlignment', 'left');

handles.unitProp_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'Position', [0.25 0.97 0.05 0.02],...
    'String', listUnitProperty,...
    'Value', 2,...
    'Callback', 'TriDiMap_runPlot');

%% Definition of the grid parameters
handles.title_numXindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.93 0.11 0.02],...
    'String', 'Number of indents along X axis:',...
    'HorizontalAlignment', 'left');

handles.value_numXindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.135 0.93 0.03 0.02],...
    'String', '25');

handles.title_numYindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.91 0.11 0.02],...
    'String', 'Number of indents along Y axis:',...
    'HorizontalAlignment', 'left');

handles.value_numYindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.135 0.91 0.03 0.02],...
    'String', '25');

%% Buttons to browse file
handles.opendata_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.84 0.05 0.06],...
    'String', 'Select file',...
    'FontSize', 10,...
    'FontWeight','bold',...
    'BackgroundColor', [0.745 0.745 0.745],...
    'Callback', 'TriDiMap_loadingData');

handles.opendata_str_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.075 0.84 0.122 0.06],...
    'String', g.config.data.data_path,...
    'FontSize', 8,...
    'BackgroundColor', [0.9 0.9 0.9],...
    'HorizontalAlignment', 'left');

%% Definition of the distance between indents
handles.title_deltaXindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.81 0.14 0.02],...
    'String', 'Distance between indents along X axis:',...
    'HorizontalAlignment', 'left');

handles.value_deltaXindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.165 0.81 0.03 0.02],...
    'String', num2str(g.config.XStep_default),...
    'Callback', 'TriDiMap_runPlot');

handles.unit_deltaXindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.195 0.81 0.03 0.02],...
    'String', '�m',...
    'HorizontalAlignment', 'center');

handles.title_deltaYindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.79 0.14 0.02],...
    'String', 'Distance between indents along Y axis:',...
    'HorizontalAlignment', 'left');

handles.value_deltaYindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.165 0.79 0.03 0.02],...
    'String', num2str(g.config.YStep_default),...
    'Callback', 'TriDiMap_runPlot');

handles.unit_deltaYindents_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.195 0.79 0.03 0.02],...
    'String', '�m',...
    'HorizontalAlignment', 'center');

%% Crop of the dataset
handles.title_MinXCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.72 0.08 0.02],...
    'String', 'Minimum indent on X',...
    'HorizontalAlignment', 'left');

handles.value_MinXCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.10 0.72 0.02 0.02],...
    'String', num2str(1),...
    'Callback', 'TriDiMap_runPlot');

handles.title_MaxXCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.02 0.70 0.08 0.02],...
    'String', 'Maximum indent on X',...
    'HorizontalAlignment', 'left');

handles.value_MaxXCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.10 0.70 0.02 0.02],...
    'String', num2str(25),...
    'Callback', 'TriDiMap_runPlot');

handles.title_MinYCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.72 0.08 0.02],...
    'String', 'Minimum indent on Y',...
    'HorizontalAlignment', 'left');

handles.value_MinYCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.21 0.72 0.02 0.02],...
    'String', num2str(1),...
    'Callback', 'TriDiMap_runPlot');

handles.title_MaxYCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'Position', [0.13 0.70 0.08 0.02],...
    'String', 'Maximum indent on Y',...
    'HorizontalAlignment', 'left');

handles.value_MaxYCrop_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'edit',...
    'Position', [0.21 0.70 0.02 0.02],...
    'String', num2str(25),...
    'Callback', 'TriDiMap_runPlot');

%% Colorbar options
handles.title_colormap_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'text',...
    'String', 'Colormap:',...
    'HorizontalAlignment', 'left');

handles.colormap_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'popupmenu',...
    'String', listColormap,...
    'Value', 1);

handles.cb_flipColormap_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'checkbox',...
    'String', 'Flip colormap',...
    'Value', 1);

%% Set of the GUI for the mapping step
if module == 1
    
    %% Definition of the property
    handles.title_property_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.76 0.04 0.02],...
        'String', 'Property:',...
        'HorizontalAlignment', 'left');
    
    handles.property_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'popupmenu',...
        'Position', [0.06 0.76 0.05 0.02],...
        'String', {'Elastic modulus';'Hardness'},...
        'Value', 2, ...
        'Callback', 'TriDiMap_runPlot');
    
    %% Pixelized data
    handles.cb_pixData_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.67 0.10 0.02],...
        'String', 'Pixelized data',...
        'Value', 1,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Remove NaN pixels (blank pixels)
    handles.cb_pixNaN_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.64 0.10 0.02],...
        'String', 'Remove NaN pixels',...
        'Value', 1,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Interpolation
    minValI = 1;
    maxValI = 4;
    handles.cb_interpMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.61 0.10 0.02],...
        'String', 'Interpolation of the map',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.pm_interpMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'popupmenu',...
        'Position', [0.12 0.61 0.05 0.02],...
        'String', listInterp,...
        'Value', 2,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Smoothing
    minValS = 1;
    maxValS = 3;
    handles.cb_smoothMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.57 0.10 0.02],...
        'String', 'Smoothing of the map',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.pm_smoothMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'popupmenu',...
        'Position', [0.12 0.57 0.05 0.02],...
        'String', listSmooth,...
        'Value', 2,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.cb_errorMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.53 0.10 0.02],...
        'String', 'Plot of the error map',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Min, Mean and Max values of the property
    handles.title_MinVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.50 0.09 0.02],...
        'String', 'Minimum property value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_MinVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.50 0.03 0.02],...
        'String', num2str(g.config.cminOld));
    
    handles.unit_MinVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.145 0.50 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_MeanVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.48 0.09 0.02],...
        'String', 'Mean property value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_MeanVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.48 0.03 0.02],...
        'String', num2str(g.config.cmaxOld));
    
    handles.unit_MeanVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.145 0.48 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_MaxVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.46 0.09 0.02],...
        'String', 'Maximum property value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_MaxVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.46 0.03 0.02],...
        'String', num2str(g.config.cmaxOld));
    
    handles.unit_MaxVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.145 0.46 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    %% Contour Plot
    handles.cb_contourPlotMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.43 0.18 0.02],...
        'String', 'Contour plot of the map',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Colorbar options
    set(handles.title_colormap_GUI, ...
        'Position', [0.02 0.40 0.04 0.02]);
    set(handles.colormap_GUI, ...
        'Position', [0.06 0.40 0.05 0.02],...
        'Callback', 'TriDiMap_runPlot');
    set(handles.cb_flipColormap_GUI, ...
        'Position', [0.115 0.40 0.085 0.02],...
        'Callback', 'TriDiMap_runPlot');
    
    handles.cb_autoColorbar_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.37 0.085 0.02],...
        'String', 'Auto colorbar',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.title_colorMin_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.34 0.09 0.02],...
        'String', 'Minimum colorbar value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_colorMin_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.34 0.03 0.02],...
        'String', num2str(g.config.cminOld),...
        'Callback', 'TriDiMap_runPlot');
    
    handles.unit_colorMin_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.145 0.34 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_colorMax_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.32 0.09 0.02],...
        'String', 'Maximum colorbar value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_colorMax_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.32 0.03 0.02],...
        'String', num2str(g.config.cmaxOld),...
        'Callback', 'TriDiMap_runPlot');
    
    handles.unit_colorMax_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.145 0.32 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_colorNum_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.30 0.09 0.02],...
        'String', 'Number of intervals:',...
        'HorizontalAlignment', 'left');
    
    handles.value_colorNum_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.115 0.30 0.03 0.02],...
        'String', '10',...
        'Callback', 'TriDiMap_runPlot');
    
    %% Normalization of the colorbar
    handles.cb_normMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.27 0.11 0.02],...
        'String', 'Normalization of the colorbar',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.pm_normMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'popupmenu',...
        'Position', [0.13 0.27 0.05 0.02],...
        'String', listVal,...
        'Value', 2,...
        'Callback', 'TriDiMap_runPlot');
    
    %% Translation of the colorbar
    handles.cb_transMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.24 0.11 0.02],...
        'String', 'Translation of the colorbar',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.value_transMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.13 0.24 0.03 0.02],...
        'String', '10',...
        'Callback', 'TriDiMap_runPlot');
    
    handles.unit_transMap_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.16 0.24 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    %% Options of the plot
    handles.cb_log_plot_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.02 0.21 0.04 0.02],...
        'String', 'Log',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.cb_grid_plot_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.06 0.21 0.04 0.02],...
        'String', 'Grid',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.cb_markers_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.10 0.21 0.05 0.02],...
        'String', 'Markers',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    handles.cb_MinMax_plot_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.15 0.21 0.05 0.02],...
        'String', 'Min/Max',...
        'Value', 0,...
        'Callback', 'TriDiMap_runPlot');
    
    if ~strcmp(g.config.MatlabRelease, '(R2014b)')
        handles.cb_tickColorBar_GUI = uicontrol('Parent', gcf,...
            'Units', 'normalized',...
            'Style', 'checkbox',...
            'Position', [0.02 0.18 0.05 0.02],...
            'String', 'Ticks',...
            'Value', 0,...
            'Callback', 'TriDiMap_runPlot');
    end
    
    %% Location of the legend
    % handles.title_legend_location = uicontrol('Parent', gcf,...
    %     'Units', 'normalized',...
    %     'Style', 'text',...
    %     'Position', [0.02 0.22 0.04 0.02],...
    %     'String', 'Legend location:',...
    %     'HorizontalAlignment', 'left');
    %
    % handles.legend_GUI = uicontrol('Parent', gcf,...
    %     'Units', 'normalized',...
    %     'Style', 'popupmenu',...
    %     'Position', [0.06 0.22 0.05 0.02],...
    %     'String', listLocationLegend,...
    %     'Value', 2,...
    %     'Callback', 'TriDiMap_runPlot');
    
    %% Get values from plot
    handles.pb_get_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'pushbutton',...
        'Position', [0.02 0.14 0.1 0.03],...
        'String', 'Get property value',...
        'Callback', 'plot_get_values');
    
    handles.title_x_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.12 0.03 0.02],...
        'String', 'X value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_x_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.05 0.12 0.03 0.02],...
        'String', '');
    
    handles.unit_x_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.08 0.12 0.03 0.02],...
        'String', '',...
        'HorizontalAlignment', 'left');
    
    handles.title_y_values_prop_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.10 0.03 0.02],...
        'String', 'Y value:',...
        'HorizontalAlignment', 'left');
    
    handles.value_y_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.05 0.10 0.03 0.02],...
        'String', '');
    
    handles.unit_y_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.08 0.10 0.03 0.02],...
        'String', '',...
        'HorizontalAlignment', 'left');
    
    handles.title_z_values_prop_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.12 0.11 0.03 0.02],...
        'String', 'Property:',...
        'HorizontalAlignment', 'left');
    
    handles.value_z_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.15 0.11 0.03 0.02],...
        'String', '');
    
    handles.unit_z_values_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.18 0.11 0.03 0.02],...
        'String', '',...
        'HorizontalAlignment', 'left');
    
    %% Plot configuration
    handles.AxisPlot_GUI = axes('Parent', gcf,...
        'Position', [0.33 0.10 0.60 0.75]);
    
    set(gcf,'CurrentAxes', handles.AxisPlot_GUI);
end

%% Others buttons
% Save
handles.save_GUI = uicontrol('Parent', gcf,...
    'Units', 'normalized',...
    'Style', 'pushbutton',...
    'Position', [0.02 0.03 0.10 0.06],...
    'String', 'SAVE',...
    'Callback', 'save_figure', ...
    'FontSize', 12,...
    'BackgroundColor', [0.745 0.745 0.745]);

if module == 1
    % Binarization
    handles.binarization_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'pushbutton',...
        'Position', [0.14 0.03 0.12 0.06],...
        'String', 'BINARIZATION',...
        'Callback', 'TriDiMap_binarization', ...
        'FontSize', 12,...
        'BackgroundColor', [0.745 0.745 0.745]);
elseif module == 2
    handles.binarization_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'pushbutton',...
        'Position', [0.14 0.03 0.12 0.06],...
        'String', 'MAPPING',...
        'Callback', 'TriDiMap_binarization', ...
        'FontSize', 12,...
        'BackgroundColor', [0.745 0.745 0.745]);
end

%% Set of the GUI for the binarization step
if module == 2
    %% Definition of the criterion
    handles.title_criterionE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.67 0.14 0.02],...
        'String', 'Threshold for the elastic modulus:',...
        'HorizontalAlignment', 'left');
    
    handles.value_criterionE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.165 0.67 0.03 0.02],...
        'String', 250,...
        'Callback', 'TriDiMap_runBin');
    
    handles.unit_criterionE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.195 0.67 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_criterionH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.65 0.14 0.02],...
        'String', 'Threshold for the hardness:',...
        'HorizontalAlignment', 'left');
    
    handles.value_criterionH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.165 0.65 0.03 0.02],...
        'String', 10,...
        'Callback', 'TriDiMap_runBin');
    
    handles.unit_criterionH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.195 0.65 0.03 0.02],...
        'String', 'GPa',...
        'HorizontalAlignment', 'center');
    
    handles.title_numThres_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.63 0.11 0.02],...
        'String', 'Number of threshold:',...
        'HorizontalAlignment', 'left', ...
        'Visible', 'off');

    handles.value_numThres_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.165 0.63 0.03 0.02],...
        'String', '20', ...
        'Visible', 'off');
    
    handles.plotAllCritVal_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'pushbutton',...
        'Position', [0.02 0.58 0.20 0.04],...
        'String', 'Plot of match = f(all threshold)',...
        'FontSize', 10,...
        'FontWeight','bold',...
        'BackgroundColor', [0.745 0.745 0.745],...
        'Visible', 'off', ...
        'Callback', 'TriDiMap_plotMatchThreshold');
    
    %% Buttons to browse image
    handles.openimage_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'pushbutton',...
        'Position', [0.02 0.50 0.05 0.06],...
        'String', 'Get Image',...
        'FontSize', 10,...
        'FontWeight','bold',...
        'BackgroundColor', [0.745 0.745 0.745],...
        'Callback', 'TriDiMap_loadingImage');
    
    handles.openimage_str_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.075 0.50 0.122 0.06],...
        'String', g.config.image.image_path,...
        'FontSize', 8,...
        'BackgroundColor', [0.9 0.9 0.9],...
        'HorizontalAlignment', 'left');
    
    %% Colorbar options
    set(handles.title_colormap_GUI, ...
        'Position', [0.02 0.46 0.04 0.02]);
    set(handles.colormap_GUI, ...
        'Position', [0.06 0.46 0.05 0.02],...
        'Callback', 'TriDiMap_runBin', ...
        'Value', 8);
    set(handles.cb_flipColormap_GUI, ...
        'Position', [0.115 0.46 0.085 0.02],...
        'Callback', 'TriDiMap_runBin');
    
    %% Match settings
    handles.title_pixelList_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'String', 'Pixels:',...
        'HorizontalAlignment', 'left', ...
        'Position', [0.02 0.42 0.04 0.02]);
    
    handles.pixelList_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'popupmenu',...
        'String', listPixel,...
        'Value', 1, ...
        'Position', [0.06 0.42 0.05 0.02],...
        'Callback', 'TriDiMap_runBin');
    
    %% Difference calculations
    handles.title_diffValE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.36 0.13 0.02],...
        'String', 'Match between E map and image',...
        'HorizontalAlignment', 'left');
    
    handles.value_diffValE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.155 0.36 0.03 0.02]);
    
    handles.unit_diffValE_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.190 0.36 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_diffValH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.33 0.13 0.02],...
        'String', 'Match between H map and image',...
        'HorizontalAlignment', 'left');
    
    handles.value_diffValH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.155 0.33 0.03 0.02]);
    
    handles.unit_diffValH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.190 0.33 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_diffValEH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.30 0.13 0.02],...
        'String', 'Match between E and H maps',...
        'HorizontalAlignment', 'left');
    
    handles.value_diffValEH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.155 0.30 0.03 0.02]);
    
    handles.unit_diffValEH_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.190 0.30 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    %% Phases ratios calculations
    handles.title_ratioLow_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.26 0.11 0.02],...
        'String', 'E - Fraction of soft phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioLow_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.26 0.03 0.02]);
    
    handles.unit_ratioLow_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.26 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_ratioHigh_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.23 0.11 0.02],...
        'String', 'E - Fraction of hard/stiff phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioHigh_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.23 0.03 0.02]);
    
    handles.unit_ratioHigh_E_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.23 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_ratioLow_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.20 0.11 0.02],...
        'String', 'H - Fraction of soft phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioLow_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.20 0.03 0.02]);
    
    handles.unit_ratioLow_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.20 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_ratioHigh_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.17 0.11 0.02],...
        'String', 'H - Fraction of hard/stiff phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioHigh_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.17 0.03 0.02]);
    
    handles.unit_ratioHigh_H_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.17 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');

    handles.title_ratioLow_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.14 0.11 0.02],...
        'String', 'I - Fraction of soft phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioLow_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.14 0.03 0.02]);
    
    handles.unit_ratioLow_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.14 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    handles.title_ratioHigh_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.02 0.11 0.11 0.02],...
        'String', 'I - Fraction of hard/stiff phase',...
        'HorizontalAlignment', 'left');
    
    handles.value_ratioHigh_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'edit',...
        'Position', [0.135 0.11 0.03 0.02]);
    
    handles.unit_ratioHigh_I_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'text',...
        'Position', [0.170 0.11 0.03 0.02],...
        'String', '%',...
        'HorizontalAlignment', 'left');
    
    %% Legend
    % handles.title_legend_location = uicontrol('Parent', gcf,...
    %     'Units', 'normalized',...
    %     'Style', 'text',...
    %     'Position', [0.02 0.13 0.04 0.02],...
    %     'String', 'Legend location:',...
    %     'HorizontalAlignment', 'left');
    %
    % handles.legend_GUI = uicontrol('Parent', gcf,...
    %     'Units', 'normalized',...
    %     'Style', 'popupmenu',...
    %     'Position', [0.06 0.13 0.05 0.02],...
    %     'String', listLocationLegend,...
    %     'Value', 2,...
    %     'Callback', 'TriDiMap_runPlot');
    handles.cb_legend_GUI = uicontrol('Parent', gcf,...
        'Units', 'normalized',...
        'Style', 'checkbox',...
        'Position', [0.115 0.42 0.04 0.02],...
        'String', 'Legend',...
        'Value', 1,...
        'Callback', 'TriDiMap_runBin');
    
    %% Plot configuration
    handles.AxisPlot_GUI_1 = axes('Parent', gcf,...
        'Position', [0.3 0.55 0.15 0.30]);
    
    handles.AxisPlot_GUI_2 = axes('Parent', gcf,...
        'Position', [0.5 0.55 0.15 0.30]);
    
    handles.AxisPlot_GUI_3 = axes('Parent', gcf,...
        'Position', [0.7 0.55 0.15 0.30]);
    
    handles.AxisPlot_GUI_4 = axes('Parent', gcf,...
        'Position', [0.3 0.10 0.15 0.30]);
    
    handles.AxisPlot_GUI_5 = axes('Parent', gcf,...
        'Position', [0.5 0.10 0.15 0.30]);
    
    handles.AxisPlot_GUI_6 = axes('Parent', gcf,...
        'Position', [0.7 0.10 0.15 0.30]);
    
end

%% Coordinates system
coordSyst(handles.MainWindow);

%% Guidata
g.handles = handles;
guidata(gcf, g);

%% Update units
TriDiMap_updateUnit;

end