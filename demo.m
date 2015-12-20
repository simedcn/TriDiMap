%% Copyright 2014 MERCIER David
function gui = demo
%% Function to run the Matlab code for the 3D mapping of indentation data

%% Define gui structure variable
gui = struct();
gui.config = struct();
gui.config.data = struct();
gui.config.numerics = struct();

%% Paths Management
% Don't move before definition of 'gui' as a struct()
try
    gui.config.tridim_root = get_tridim_root; % ensure that environment is set
catch
    [startdir, dummy1, dummy2] = fileparts(mfilename('fullpath'));
    cd(startdir);
    commandwindow;
    path_management;
    gui.config.tridim_root = get_tridim_root; % ensure that environment is set
end

gui.config.data.data_path = '.\data_indentation';

%% Set variables
gui.config.data.normalizationStep = 0; % 0 if no normalization and 1 if normalization step
gui.config.data.N_XStep = 5; % Number of steps along X axis
gui.config.data.N_YStep = 10; % Number of steps along Y axis
gui.config.data.XStep = 15; % X step in microns
gui.config.data.YStep = 15; % Y step in microns

%% Load data from Excel files
[config, gui.data] = ...
    TriDiMap_loadingData(gui.config.data.data_path, ...
    gui.config.data.N_XStep, gui.config.data.N_YStep);

gui.config.data_path = config.data_path;
gui.config.flag.flag_data = config.flag.flag_data;

if gui.config.flag.flag_data
    %% Normalization step
    normStep = gui.config.data.normalizationStep;
    if normStep
        % Normalization of elastic modulus
        gui.data.expValues_mat_average.YM = mean(mean(gui.data.expValues_mat.YM));
        gui.data.expValues_mat_norm.YM = gui.data.expValues_mat.YM - gui.data.expValues_mat_average.YM;
        % Normalization of hardness
        gui.data.expValues_mat_average.H = mean(mean(gui.data.expValues_mat.H));
        gui.data.expValues_mat_norm.H = gui.data.expValues_mat.H - gui.data.expValues_mat_average.H;
    end
    
    %% Run the 3D maps
    if normStep
        TriDiMap_mapping_plotting(gui.config.data.XStep, gui.config.data.YStep, ...
            gui.data.expValues_mat_norm.YM, 1, normStep);
        TriDiMap_mapping_plotting(gui.config.data.XStep, gui.config.data.YStep, ...
            gui.data.expValues_mat_norm.H, 2, normStep);
    else
        TriDiMap_mapping_plotting(gui.config.data.XStep, gui.config.data.YStep, ...
            gui.data.expValues_mat.YM, 1, normStep);
        TriDiMap_mapping_plotting(gui.config.data.XStep, gui.config.data.YStep, ...
            gui.data.expValues_mat.H, 2, normStep);
    end
end
end