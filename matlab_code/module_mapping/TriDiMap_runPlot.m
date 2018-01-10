%% Copyright 2014 MERCIER David
function TriDiMap_runPlot
%% Function to run the mapping
reset(gca);
gui = guidata(gcf);
if ~gui.config.saveFlag
    TriDiMap_updateUnit_and_GUI;
end
TriDiMap_getParam;
gui = guidata(gcf);
config = gui.config;
strUnit_Property = ...
    get_value_popupmenu(gui.handles.unitProp_GUI, listUnitProperty);

if config.rawData == 8 % Code for 3D slices
    if config.SliceFlagData == 0
        TriDiMap_loadingAllTests;
    end
    gui = guidata(gcf);
    
    max_h = zeros(length(gui.data),1);
    for ii = 1:length(gui.data)
        %gui.data(ii).data_h(isinf(gui.data(ii).data_h)) = NaN;
        gui.data(ii).data_h(gui.data(ii).data_h > 1e6) = NaN;
        gui.data(ii).data_L(gui.data(ii).data_L > 1e6) = NaN;
        gui.data(ii).data_E(gui.data(ii).data_E > 1e6) = NaN;
        gui.data(ii).data_H(gui.data(ii).data_H > 1e6) = NaN;
        max_h(ii) = max(gui.data(ii).data_h);
    end
    max_z_min = nanmin(max_h);
    min_z = 50;
    if max_z_min < min_z
        warning('Minimum final depth founded lower than minimum depth!');
        max_z_min = 100;
    end
    sliceNum = gui.config.sliceNum;
    IndSlice = struct();
    
    for ii = 1:length(gui.data)
        %             IndSlice(1,ii).Val = find(gui.data(ii).data_h < (0.005*max_z_min) ...
        %                 & gui.data(ii).data_h > 0);
        IndSlice(1,ii).Val = find(gui.data(ii).data_h > 0.95*min_z ...
            & gui.data(ii).data_h < 1.05*min_z);
        for jj = 2:sliceNum-1
            IndSlice(jj,ii).Val = find(gui.data(ii).data_h > (0.95*((jj-1)/(sliceNum-1))*(max_z_min-min_z))+min_z ...
                & gui.data(ii).data_h < (1.05*((jj-1)/(sliceNum-1))*(max_z_min-min_z))+min_z);
        end
        IndSlice(sliceNum,ii).Val = find(gui.data(ii).data_h > (0.95*max_z_min) ...
            & gui.data(ii).data_h < 1.05*max_z_min);
    end
    
    slicePix = zeros(sliceNum,length(gui.data));
    if config.property == 1
        
        for ii = 1:length(gui.data)
            for jj = 1:sliceNum
                slicePix(jj,ii) = ...
                    nanmean(gui.data(ii).data_E(IndSlice(jj,ii).Val));
            end
        end
    elseif config.property == 2
        for ii = 1:length(gui.data)
            for jj = 1:sliceNum
                slicePix(jj,ii) = ...
                    nanmean(gui.data(ii).data_H(IndSlice(jj,ii).Val));
            end
        end
    end
    
    % Reshape data matrices for each slice
    NX = config.N_XStep;
    NY = config.N_YStep;
    slicePix_mat = zeros(NX,NY,sliceNum);
    try
        for ii = 1:sliceNum
            slicePix_mat(:,:,ii) = reshape(slicePix(ii,:),[NX,NY]);
            
            % Flip even columns to respect nanoindentation pattern
            for evenIndex = 2:2:NY
                slicePix_mat(:,evenIndex,ii) = ...
                    flipud(slicePix_mat(:,evenIndex,ii));
            end
        end
        config.flagValid = 1;
    catch
        slicePix_mat = 0;
        errordlg('Wrong inputs for number of indents along X or/and Y axis !');
        config.flagValid = 0;
    end
    for ii = 1:sliceNum
        [slicePix_mat(:,:,ii), ratioNan] = ...
            TriDiMap_cleaningData(slicePix_mat(:,:,ii)); % Fill empty and NaN pixels
    end
    gui.slice_data.slicePix_mat = slicePix_mat;
    
    % Mesh definition
    x_step = config.XStep;
    y_step = config.YStep;
    z_step = (1/(sliceNum-1))*(max_z_min-min_z);
    
    [xData_interp, yData_interp, zData_interp] = ...
        meshgrid(0:x_step:(size(gui.slice_data.slicePix_mat,1)-1)*x_step, ...
        0:y_step:(size(gui.slice_data.slicePix_mat,2)-1)*y_step, ...
        min_z:z_step:max_z_min);
    if get(gui.handles.cb_interpMap_GUI, 'Value')
        gui.slice_data.xData_interp = xData_interp./(2^(config.interpFact));
        gui.slice_data.yData_interp = yData_interp./(2^(config.interpFact));
        gui.slice_data.zData_interp = zData_interp./(2^(config.interpFact));
    else
        gui.slice_data.xData_interp = xData_interp;
        gui.slice_data.yData_interp = yData_interp;
        gui.slice_data.zData_interp = zData_interp;
    end
    
    gui.config.legendSlice = strcat('Indentation depth (',...
        gui.config.strUnit_Property, ')');
    gui.config.sliceNum = sliceNum;
    guidata(gcf, gui);
    TriDiMap_mapping_plotting;
    TriDiMap_option_plotting;
    gui = guidata(gcf);
else
    if config.flag_data
        if config.property == 1 || config.property == 4 || config.property == 6
            if ~config.flagZplot
                data2use = gui.data.expValues_mat.YM;
            else
                data2use = gui.data3D.meanZVal_YM;
            end
        elseif config.property == 2 || config.property == 5 || config.property == 7
            if ~config.flagZplot
                data2use = gui.data.expValues_mat.H;
            else
                data2use = gui.data3D.meanZVal_H;
            end
        elseif config.property == 3
            data2use_E = gui.data.expValues_mat.YM;
            data2use_H = gui.data.expValues_mat.H;
        end
        if config.property < 3
            [dataCleaned, ratioNan] = TriDiMap_cleaningData(data2use);
            set(gui.handles.value_NaNratio_GUI, 'String', num2str(ratioNan));
            if config.noNan
                data2use = dataCleaned;
            end
        end
        if config.property ~= 3
            %% Crop data
            [data2use, config.flagCrop] = TriDiMap_cropping(data2use);
            if length(data2use) == 1
                config.flag_data = 0;
            end
        else
            [data2use_E, config.flagCrop] = TriDiMap_cropping(data2use_E);
            [data2use_H, config.flagCrop] = TriDiMap_cropping(data2use_H);
            if length(data2use_E) == 1 && length(data2use_H) == 1
                config.flag_data = 0;
            end
        end
    end
    
    if config.property < 3
        %% Clean data
        if config.flag_data
            %% Normalization of dataset
            if config.normalizationStep && ~config.translationStep
                if config.normalizationStepVal == 1
                    data2use = data2use/(min(min(data2use)));
                elseif config.normalizationStepVal == 2
                    data2use = data2use/(nanmean(nanmean(data2use)));
                elseif config.normalizationStepVal == 3
                    data2use = data2use/(max(max(data2use)));
                end
                display('Translation not possible because normalization is active.');
            end
            
            %% Translation step
            if config.translationStep && ~config.normalizationStep
                data2use = data2use + config.translationStepVal;
                data2use((data2use)<0) = 0;
                display('Negative values for the property are replaced by 0.');
                display('Normalization not possible because translation is active.');
            end
            
            %% Interpolating, smoothing and binarizing steps of dataset
            if config.noNan
                [gui.data.expValuesInterp, gui.data.expValuesSmoothed, ...
                    gui.data.expValuesInterpSmoothed] = ...
                    TriDiMap_interpolation_smoothing(...
                    data2use, ...
                    config.interpBool, config.interpFact, ...
                    config.smoothBool, config.smoothFact);
            else
                gui.data.expValuesInterp = data2use;
                gui.data.expValuesSmoothed = data2use;
                gui.data.expValuesInterpSmoothed = data2use;
            end
            
            %% Grid meshing
            x_step = config.XStep;
            y_step = config.YStep;
            
            if config.N_XStep_default == config.N_YStep_default
                gui.data.xData = 0:x_step:(size(data2use,1)-1)*x_step;
                gui.data.yData = 0:y_step:(size(data2use,2)-1)*y_step;
            elseif config.N_XStep_default ~= config.N_YStep_default
                gui.data.xData = 0:x_step:(size(data2use,1)-1)*x_step;
                gui.data.yData = 0:y_step:(size(data2use,2)-1)*y_step;
            end
            if config.flagZplot
                gui.data.yData = -gui.data.yData;
            end
            
            if config.N_XStep ~= config.N_YStep
                [gui.data.xData_markers, gui.data.yData_markers] = ...
                    meshgrid(1:length(gui.data.xData),1:length(gui.data.yData));
                gui.data.xData_markers = (gui.data.xData_markers-1)*x_step;
                gui.data.yData_markers = (gui.data.yData_markers-1)*y_step;
            else
                [gui.data.xData_markers, gui.data.yData_markers] = ...
                    meshgrid(gui.data.xData, gui.data.yData);
            end
            
            if config.rawData == 1
                gui.data.xData_interp = gui.data.xData;
                gui.data.yData_interp = gui.data.yData;
                if get(gui.handles.cb_errorMap_GUI, 'Value')
                    [xData_interp, yData_interp] = ...
                        meshgrid(0:x_step:(size(gui.data.expValuesInterpSmoothed,1)-1)*x_step, ...
                        0:y_step:(size(gui.data.expValuesInterpSmoothed,2)-1)*y_step);
                    gui.data.xData_interp = xData_interp./(2^(config.interpFact));
                    gui.data.yData_interp = yData_interp./(2^(config.interpFact));
                end
            else
                [xData_interp, yData_interp] = ...
                    meshgrid(0:x_step:(size(gui.data.expValuesInterpSmoothed,1)-1)*x_step, ...
                    0:y_step:(size(gui.data.expValuesInterpSmoothed,2)-1)*y_step);
                if get(gui.handles.cb_interpMap_GUI, 'Value')
                    gui.data.xData_interp = xData_interp./(2^(config.interpFact));
                    gui.data.yData_interp = yData_interp./(2^(config.interpFact));
                else
                    gui.data.xData_interp = xData_interp;
                    gui.data.yData_interp = yData_interp;
                end
            end
        end
        
        %% Legend + Map
        if config.flag_data
            gui.data.data2plot = gui.data.expValuesInterpSmoothed;
            
            minVal = round(100*(min(min(gui.data.data2plot))))/100;
            meanVal = round(100*(nanmean(nanmean(gui.data.data2plot))))/100;
            maxVal = round(100*(max(max(gui.data.data2plot))))/100;
            set(gui.handles.value_MinVal_GUI, 'String', num2str(minVal));
            set(gui.handles.value_MeanVal_GUI, 'String', num2str(meanVal));
            set(gui.handles.value_MaxVal_GUI, 'String', num2str(maxVal));
            
            if ~config.normalizationStep
                if config.property == 1
                    config.legend = strcat({'Elastic modulus ('},config.strUnit_Property, ')');
                    %config.legend = 'Module d''\''elasticit\''e (GPa)';
                elseif config.property == 2
                    config.legend = strcat({'Hardness ('},config.strUnit_Property, ')');
                    %config.legend = 'Duret\''e (GPa)';
                end
                
            elseif config.normalizationStep > 0
                if config.normalizationStepVal == 1
                    if config.property == 1
                        config.legend = 'Normalized elastic modulus by minimum elastic modulus value';
                    elseif config.property == 2
                        config.legend = 'Normalized hardness by minimum hardness value';
                    end
                elseif config.normalizationStepVal == 2
                    if config.property == 1
                        config.legend = 'Normalized elastic modulus by mean elastic modulus value';
                    elseif config.property == 2
                        config.legend = 'Normalized hardness by mean hardness value';
                    end
                elseif config.normalizationStepVal == 3
                    if config.property == 1
                        config.legend = 'Normalized elastic modulus by maximum elastic modulus value';
                    elseif config.property == 2
                        config.legend = 'Normalized hardness by maximum hardness value';
                    end
                end
            end
            gui.config = config;
            guidata(gcf, gui);
            if get(gui.handles.cb_errorMap_GUI, 'Value')
                TriDiMap_error_plotting;
            else
                TriDiMap_mapping_plotting;
            end
            TriDiMap_option_plotting;
            gui = guidata(gcf);
        else
            errordlg(['First set indentation grid parameters and load an Excel file '...
                'to plot a property map !']);
        end
    elseif config.property == 3
        if ~get(gui.handles.cb_sectPlot_GUI, 'Value')
            color1 = 'k+'; colorT1 = 'Black';
            color2 = 'k+'; colorT2 = 'Black';
            color3 = 'k+'; colorT3 = 'Black';
            color4 = 'k+'; colorT4 = 'Black';
        else
            color1 = 'k+'; colorT1 = 'Black';
            color2 = 'r*'; colorT2 = 'Red';
            color3 = 'go'; colorT3 = 'Green';
            color4 = 'bx'; colorT4 = 'Blue';
        end
        if gui.config.logZ
            loglog(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                color1, 'Linewidth', 1.5);
            hold on;
            loglog(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                color2, 'Linewidth', 1.5);
            hold on;
            loglog(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                color3, 'Linewidth', 1.5);
            hold on;
            loglog(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                color4, 'Linewidth', 1.5);
        else
            plot(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                color1, 'Linewidth', 1.5);
            hold on;
            plot(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                color2, 'Linewidth', 1.5);
            hold on;
            plot(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines), ...
                color3, 'Linewidth', 1.5);
            hold on;
            plot(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines), ...
                color4, 'Linewidth', 1.5);
        end
        if get(gui.handles.cb_sectMVPlot_GUI, 'Value')
            meanH = round(10*nanmean(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines)))/10;
            meanE = round(10*nanmean(data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines)))/10;
            x = 0.7*gui.config.HVal_ThresLines;
            y = gui.config.EVal_ThresLines;
            text(x,0.10*y,strcat('H = ',num2str(meanH), gui.config.strUnit_Property), 'Color', colorT1);
            text(x,0.05*y,strcat('E = ',num2str(meanE), gui.config.strUnit_Property), 'Color', colorT1);
            meanH = round(10*nanmean(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines)))/10;
            meanE = round(10*nanmean(data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E < gui.config.EVal_ThresLines)))/10;
            x = 0.7*gui.config.HVal_ThresLines;
            y = max(max(data2use_E));
            text(x,0.95*y,strcat('H = ',num2str(meanH), gui.config.strUnit_Property), 'Color', colorT2);
            text(x,0.90*y,strcat('E = ',num2str(meanE), gui.config.strUnit_Property), 'Color', colorT2);
            meanH = round(10*nanmean(data2use_H(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines)))/10;
            meanE = round(10*nanmean(data2use_E(data2use_H < gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines)))/10;
            x = 1.1*gui.config.HVal_ThresLines;
            y = gui.config.EVal_ThresLines;
            text(x,0.10*y,strcat('H = ',num2str(meanH), gui.config.strUnit_Property), 'Color', colorT3);
            text(x,0.05*y,strcat('E = ',num2str(meanE), gui.config.strUnit_Property), 'Color', colorT3);
            meanH = round(10*nanmean(data2use_H(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines)))/10;
            meanE = round(10*nanmean(data2use_E(data2use_H > gui.config.HVal_ThresLines & data2use_E > gui.config.EVal_ThresLines)))/10;
            x = 1.1*gui.config.HVal_ThresLines;
            y = max(max(data2use_E));
            text(x,0.95*y,strcat('H = ',num2str(meanH), gui.config.strUnit_Property), 'Color', colorT4);
            text(x,0.90*y,strcat('E = ',num2str(meanE), gui.config.strUnit_Property), 'Color', colorT4);
        end
        hold on;
        hXLabel = xlabel(strcat({'Hardness ('},gui.config.strUnit_Property, ')'));
        hYLabel = ylabel(strcat({'Elastic modulus ('},gui.config.strUnit_Property, ')'));
        set([hXLabel, hYLabel], ...
            'Color', [0,0,0], 'FontSize', gui.config.FontSizeVal, ...
            'Interpreter', 'Latex');
        
        if gui.config.plotThresLines
            xData_HThres = ones(1,2001) * gui.config.HVal_ThresLines;
            yData_HThres = 0:1:2000;
            xData_EThres = 0:1:200;
            yData_EThres = ones(1,201) * gui.config.EVal_ThresLines;
            plot(xData_HThres, yData_HThres, '-.k', 'Linewidth', 1.5);
            hold on;
            plot(xData_EThres, yData_EThres, '--r', 'Linewidth', 1.5);
            hold on;
            %         ellipse(gui.config.HVal_ThresLines, gui.config.EVal_ThresLines, ...
            %             0,0,0);
        end
        
        xlim([0 max(max(data2use_H))]);
        ylim([0 max(max(data2use_E))]);
        
        if gui.config.grid
            grid on;
        else
            grid off;
        end
        
    elseif config.property == 4 || config.property == 5
        if config.flag_data
            % Histograms plot
            numberVal = size(data2use,1)*size(data2use,2);
            data2useVect = reshape(data2use, [1,numberVal]);
            indNaN = find(isnan(data2useVect));
            data2useVect(indNaN) = [];
            binsize = gui.config.binSize;
            minbin = gui.config.MinHistVal;
            maxbin = gui.config.MaxHistVal;
            CatBin = minbin:binsize:maxbin;
            Hist_i = histc(data2useVect,CatBin);
            Prop_pdf = Hist_i/numberVal;
            Prop_pdf = Prop_pdf/binsize;
            SumProp_pdf = sum(Prop_pdf);
            SumTot = SumProp_pdf .* binsize;
            if  gui.config.licenceStat_Flag
                if ~get(gui.handles.cb_plotErrorPDF_GUI, 'Value')
                    if ~get(gui.handles.cb_deconvolutionHist_GUI, 'Value')
                        bar(CatBin,Prop_pdf,'FaceColor',[0.5 0.5 0.5],'EdgeColor','none', ...
                            'LineWidth', 1.5);
                        set(gcf, 'renderer', 'opengl');
                        xlim([0 maxbin]);
                        if config.property == 4
                            xlabel(strcat('Elastic modulus (',strUnit_Property, ')'));
                        elseif config.property == 5
                            xlabel(strcat('Hardness (',strUnit_Property, ')'));
                        end
                        ylabel('Frequency density');
                        gui.config.flag_fit = 0;
                    else
                        exphist = [CatBin' Prop_pdf'];
                        M = str2num(get(gui.handles.value_PhNumHist_GUI, 'String'));
                        maxiter = str2num(get(gui.handles.value_IterMaxHist_GUI, 'String'));
                        limit = str2num(get(gui.handles.value_PrecHist_GUI, 'String'));
                        gui.results.GaussianFit = ...
                            TriDiMap_runDeconvolution(data2useVect', exphist, M, ...
                            maxiter, limit, config.property, strUnit_Property);
                        gui.config.flag_fit = 1;
                    end
                    hold on;
                else
                    if gui.config.flag_fit
                        gui.results.errorFit = ...
                            (Prop_pdf' - gui.results.GaussianFit')./Prop_pdf';
                        gui.results.errorFit(gui.results.errorFit==-Inf) = 0;
                        gui.results.errorFit(gui.results.errorFit==+Inf) = 0;
                        plot(gui.results.errorFit, '+r','LineWidth',2);
                        xlim([0 maxbin]);
                        ylim([-max(abs(gui.results.errorFit)) ...
                            max(abs(gui.results.errorFit))]);
                        if config.property == 4
                            xlabel(strcat('Elastic modulus (',strUnit_Property, ')'));
                        elseif config.property == 5
                            xlabel(strcat('Hardness (',strUnit_Property, ')'));
                        end
                        ylabel('Error (%)');
                    else
                        set(gui.handles.cb_plotErrorPDF_GUI,'Value',0);
                        TriDiMap_runPlot;
                        errordlg('First run deconvolution process!');
                    end
                end
            else
                set(gui.handles.cb_deconvolutionHist_GUI,'Value',0);
                cla;
                errordlg('No licence for the Statistics_Toolbox!');
            end
        else
            errordlg(['First set indentation grid parameters and '...
                'load an Excel file to plot a property map !']);
        end
        
    elseif config.property > 5
        if gui.config.licenceStat_Flag
            numberVal = size(data2use,1)*size(data2use,2);
            data2useVect = reshape(data2use, [1,numberVal]);
            indNaN = find(isnan(data2useVect));
            data2useVect(indNaN) = [];
            h_CDF = cdfplot(data2useVect);
            xdataCDF = get(h_CDF,'XData');
            xdataCDF(1) = 0;
            xdataCDF(end) = xdataCDF(end-1);
            ydataCDF = get(h_CDF,'YData');
            hold on
            %     x = round(min(data2useVect)*10)/10:0.1:round(max(data2useVect)*10)/10;
            %     f = evcdf(x,round(mean(data2useVect)*10)/10,20);
            %     plot(x,f,'-r', 'LineWidth', 1.5)
            delete(findall(findall(gcf,'Type','axe'),'Type','text'));
            %     legend('Experimental','Theoretical','Location','NW');
            if config.property == 6
                xlabel(strcat('Elastic modulus (',strUnit_Property, ')'));
            elseif config.property == 7
                xlabel(strcat('Hardness (',strUnit_Property, ')'));
            end
            ylabel('Cumulative density function');
            set(h_CDF, 'LineStyle', '-', 'Color', 'k' , 'LineWidth', 2);
            if get (gui.handles.cb_WeibullFit_GUI, 'Value')
                % Fit Weibull
                OPTIONS = algoMinimization;
                gui.cumulativeFunction.ydata_cdf_Fit = ...
                    TriDiMap_Weibull_cdf(OPTIONS, xdataCDF, ydataCDF);
                plot(xdataCDF, gui.cumulativeFunction.ydata_cdf_Fit, '-r', ...
                    'LineWidth', 1.5);
            end
            gui.results.xdataCDF = xdataCDF;
            gui.results.ydataCDF = ydataCDF;
        else
            set(gui.handles.cb_deconvolutionHist_GUI,'Value',0);
            cla;
            errordlg('No licence for the Statistics_Toolbox!');
        end
    end
    if config.flag_data
        if config.property < 3
            coordSyst(gui.handles.MainWindow);
        else
            set(0, 'currentfigure', gui.handles.MainWindow);
            try
                delete(findall(gcf,'Tag','annotation'));
            catch
            end
        end
    end
end
guidata(gcf, gui);
if gui.config.saveFlag
    TriDiMap_updateUnit_and_GUI;
end
end