classdef PlotVectorImageChannels < imagem.gui.Tool & imagem.gui.events.ImageDisplayListener
% Open a plot frame and display the channels of selected points.
%
%   Class PlotVectorImageChannels
%
%   Example
%   PlotVectorImageChannels
%
%   See also
%

% ------
% Author: David Legland
% e-mail: david.legland@inra.fr
% Created: 2019-11-15,    using Matlab 9.7.0.1190202 (R2019b)
% Copyright 2019 INRA - BIA-BIBS.


%% Properties
properties
    Handles;
    
    LastClickedPoint;

end % end properties


%% Constructor
methods
    function obj = PlotVectorImageChannels(viewer, varargin)
        % Constructor for PlotVectorImageChannels class
        obj = obj@imagem.gui.Tool(viewer, 'PlotVectorImageChannels');
        
        % initialize properties
        obj.Handles = struct();
    end

end % end constructors


%% Implements Tool methods
methods
    function select(obj) %#ok<*MANU>
        disp('select PlotVectorImageChannels');
        
        % creates a new figure for displaying spectrum
        obj.Handles.CProfileFigure = figure( ...
            'Name', 'Channels', ...
            'MenuBar', 'None', ...
            'NumberTitle', 'Off');
        set(obj.Handles.CProfileFigure, 'Name', 'Spectral Profile');
        
%         % add to list of sub-figures
%         obj.Handles.SubFigures = [obj.Handles.SubFigures, obj.Handles.ZProfileFigure];
        
        % get image 
        img = obj.Viewer.Doc.Image;
        displayRange = [min(img.Data(:)) max(img.Data(:))];
        
        % configure axis
        ax = gca;
        hold(ax, 'on');
        set(ax, 'xlim', [0 channelNumber(img)+1]);
        set(ax, 'ylim', displayRange);
        titleStr = 'Spectral Profile';
        if ~isempty(img.Name)
            titleStr = [titleStr ' of ' img.Name];
        end
        title(ax, titleStr);
        xlabel(ax, 'Channel');
        ylabel(ax, 'Channel values');
        
        channelNames = obj.Viewer.Doc.Image.ChannelNames;
        if ~isempty(channelNames)
            set(ax, 'XTick', 1:length(channelNames))
            set(ax, 'XTickLabels', channelNames)
        end
                
        % store settings
        userdata = struct('profiles', [], 'profileHandles', []);
        set(gca, 'userdata', userdata);
        obj.Handles.CProfileAxis = ax;
        obj.Handles.CProfileCurve = [];
        
%         % set menu entry to true
%         set(src, 'Checked', 'On');

        % use this tool as image display listener
        addImageDisplayListener(obj.Viewer, obj);
    
    end
    
    function deselect(obj)
        disp('deselect PlotVectorImageChannels');
    end
    
    
end % general methods

%% Overload default Tool methods
methods
    function b = isActivable(obj)
        doc = currentDoc(obj.Viewer);
        b = ~isempty(doc) && ~isempty(doc.Image);
        if b
            b = b && isVectorImage(doc.Image);
        end
    end
end


%% Implements Mouse Listener methods
methods
    function onMouseButtonPressed(obj, hObject, eventdata) %#ok<INUSD>

        pos = get(obj.Viewer.Handles.ImageAxis, 'CurrentPoint');
        obj.LastClickedPoint = pos(1,:);

        img = obj.Viewer.Doc.Image;
%         coord = round(pointToIndex(img, [pos(1, 1:2) obj.Viewer.SliceIndex]));
        coord = round(pointToIndex(img, pos(1, 1:2)));
        coord = coord(1:2);
        
        % control on bounds of image
        if sum(coord < 1) > 0 || sum(coord > [size(img, 1) size(img,2)]) > 0
            return;
        end

        % extract channel values
        profile = permute(img.Data(coord(1), coord(2), :, :), [4 3 1 2]);
        
        hCurve = obj.Handles.CProfileCurve;
        if isempty(hCurve)
            % create a new curve
            switch obj.Viewer.Doc.ChannelDisplayType
                case 'Curve'
                    obj.Handles.CProfileCurve = plot(obj.Handles.CProfileAxis, profile, 'b');
                case 'Bar'
                    obj.Handles.CProfileCurve = bar(obj.Handles.CProfileAxis, profile, 'b');
                case 'Stem'
                    obj.Handles.CProfileCurve = stem(obj.Handles.CProfileAxis, profile, 'b');
                otherwise
                    warning('Unknown channel display type');
            end
        else
            % update existing handle with new position
            switch obj.Viewer.Doc.ChannelDisplayType
                case 'Curve'
                    set(obj.Handles.CProfileCurve, 'YData', profile);
                case 'Bar'
                    set(obj.Handles.CProfileCurve, 'YData', profile);
                case 'Stem'
                    set(obj.Handles.CProfileCurve, 'YData', profile);
                otherwise
                    warning('Unknown channel display type');
            end
        end
        
%         % add profile to axis user data
%         userdata = get(obj.Handles.CProfileAxis, 'userdata');
% %         if strcmp(get(obj.Handles.Figure, 'SelectionType'), 'normal')
% %             % replace profile list with current profile
% %             userdata.profiles = profile;
% %             delete(userdata.profileHandles);
%             h = plot(obj.Handles.CProfileAxis, profile, 'b');
% %             userdata.profileHandles = h;
% %         else
% %             % add the current profile to profile list
% %             userdata.profiles = [userdata.profiles profile];
% %             h = plot(obj.Handles.ZProfileAxis, profile, 'b');
% %             userdata.profileHandles = [userdata.profileHandles h];
% %         end
%         
%         set(obj.Handles.CProfileAxis, 'userdata', userdata);

    end
    
    function onMouseButtonReleased(obj, hObject, eventdata) %#ok<INUSD>
    end
    
    function onMouseMoved(obj, hObject, eventdata) %#ok<INUSD>
    end
end

end % end classdef

