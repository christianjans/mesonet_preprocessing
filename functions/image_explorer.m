% This is a helper function that lets us explore multi-frame images,
% e.g. VSDI / Ca2+
%
% Let's use some of the cool stuff we learned from Aaron's great lecture
% on Saturday

% Remember: You can destroy objects using their handle.
% Call object's destructor: 
% delete(h);

function f_h = image_explorer(image_stack,FrameRate,RHR)

if nargin == 1
	FrameRate=1;
end

% House keeping - assume all images have the same size
width   = size(image_stack,1);
height  = size(image_stack,2);
nFrames = size(image_stack,3);
times   = 1:nFrames;

f_h = figure;

% Recall how we can change object properties.
% What if I forgot what properties my object has?
% get(f_h)
%set(f_h,'name','Image Explorer');

% add image
ax(1) = axes('position',[0.1,0.4,0.5,0.5],'NextPlot','Add', ...
    'XLim',[1 width],'YDir','Reverse','YLim',[1 height]);
% Above axes correnspond to what Matlab does by default when using imagesc
% Use the following to have origin at (0,0).
% WARNING: This has an effect on both mask and image in the VSDI example
% which then have to be flipped (flipud).
% See image_preprocessing_AYSchumann.m for more details.
%ax(1) = axes('position',[0.1,0.4,0.5,0.5],'NextPlot','Add', ...
%    'XLim',[1 width],'YLim',[1 height]);



image_h = imagesc(image_stack(:,:,1));
colorbar('location','EastOutside','position',[0.65 0.4 0.05 0.5]);
% xlabel 'x';
% ylabel 'y';
title 'Frame: 1 - Time: 0s';

% add time series
pickX   = fix(width/2);
pickY   = fix(height/2);

% add markers to image (create unvisible copies for later rectangular range selection)
l_h(1)  = plot([pickX,pickX],[1,height],':k');
l_h(2)  = plot([1,width],[pickY,pickY],':k');
l_h(3)  = plot([pickX,pickX],[1,height],':k','Visible','off'); 
l_h(4)  = plot([1,width],[pickY,pickY],':k','Visible','off');

% add panel for pixel time series
ax(2) = axes('position',[0.1,0.05,0.5,0.2],'NextPlot','Replace');%, ...
% image_stack(pickX,pickY,:) will be a 1x1xnFrames array
% -> need to reduce dimensionality via squeeze
trace_h = plot(times,squeeze(image_stack(pickX,pickY,:)));

% add UI for frame slider
frameslider_h = uicontrol('Style', 'slider', 'String','FrameNr.','Units','Normalized',...
                        'Position', [0.1,0.29,0.5,0.04],...
                        'Callback', @updateFrame,... 
                        'Value', 1,...
                        'Min', 1, 'Max', nFrames, 'SliderStep', [1 1]/(nFrames-1),...
                        'ForegroundColor','g');
                    
% add UI for time series
timeseries_h = uicontrol('Style', 'Pushbutton', ...
    'String',['Get Pixel TS (',num2str(pickX),' , ',num2str(pickY),')'], ...
    'Units','Normalized',...
    'Position', [0.625,0.2,0.3,0.04],...
    'Callback', @doGetTimeSeries,... 
    'ForegroundColor','k'); 

average_h = uicontrol('Style', 'Pushbutton', ...
    'String','Get RectAvg TS [(--,--),(--,--)]', ...
    'Units','Normalized',...
    'Position', [0.625,0.15,0.3,0.04],...
    'Callback', @doGetRecAverage,... 
    'ForegroundColor','k'); 

if nargin ==3
	ROI_h = uicontrol('Style', 'Pushbutton', ...
		'String','Add ROI Labels', ...
		'Units','Normalized',...
		'Position', [0.625,0.1,0.3,0.04],...
		'Callback', @addROI,... 
		'ForegroundColor','k');
end

% UI helper functions
function updateFrame(varargin)
    % Dragging the slider might result in non-integer values
    FrameNr = round(get(frameslider_h,'Value'));
    set(frameslider_h,'Value',FrameNr);
    
    % Update Image Plot
    set(image_h,'CData',image_stack(:,:,FrameNr));
    %axes(ax(1));
    %image_h = imagesc(image_stack(:,:,FrameNr));
    
    % Bring markes to foreground
    uistack(l_h,'top')
    
    % Update title
    % 'Title', 'XLabel', ... are handles themselves and matlab gets
    % sometimes confused when using axes handle directly
    % Problematic: set(ax(1),'title',['Frame: ',num2str(FrameNr)]);
    set(get(ax(1),'Title'),'String',['Frame: ',num2str(FrameNr),' - Time: ',num2str(1*(FrameNr-1)/FrameRate),'s']);
end

function doGetTimeSeries(varargin)
    % get user input
    [pickX,pickY] = ginput(1);
    
    % get integers
    pickX = round(pickX); 
    pickY = round(pickY);
    
    % x,y coordinates outside plot window are meaningless
    pickX = min(max(pickX,1),width);
    pickY = min(max(pickY,1),height);
       
    % update marker in image
    set(l_h(1),'XData',[pickX,pickX],'YData',[1,height]);
    set(l_h(2),'XData',[1,width],'YData',[pickY,pickY]);
    set(l_h(3),'Visible','off');
    set(l_h(4),'Visible','off');
    
    % update button
    set(timeseries_h,'String',['Get Pixel TS (',num2str(pickX),' , ',num2str(pickY),')']);
    
    % update time series
    set(trace_h,'YData',squeeze(image_stack(pickX,pickY,:)));
  
end

function doGetRecAverage(varargin)
    % get user input
    [pickX,pickY] = ginput(2);
    
    % get integers and sort in ascending order
    pickX = sort(round(pickX)); 
    pickY = sort(round(pickY));
    
    % x,y coordinates outside plot window are meaningless
    pickX = min(max(pickX,[1,1]'),[width,width]');
    pickY = min(max(pickY,[1,1]'),[height,height]');
    
    % do num2str conversion at once -> note those are cells!
    pickXstr = strtrim(cellstr(num2str(pickX))');
    pickYstr = strtrim(cellstr(num2str(pickY))');
    
    % obtain average time series
    avgTS = mean(reshape(image_stack(pickX(1):pickX(2),pickY(1):pickY(2),:),[],nFrames));
    
    % update button
    set(average_h,'String', ...
        ['Get RectAvg TS [(',pickXstr{1},',',pickXstr{2},'),(',pickYstr{1},',',pickYstr{2},')]']);
       
    % update markers
    set(l_h(1),'XData',[pickX(1),pickX(1)],'YData',[1 height]);
    set(l_h(2),'XData',[pickX(2),pickX(2)],'YData',[1 height]);
    set(l_h(3),'XData',[1,width],'YData',[pickY(1),pickY(1)],'Visible','on');
    set(l_h(4),'XData',[1,width],'YData',[pickY(2),pickY(2)],'Visible','on');
    
    % update time series
    set(trace_h,'YData',avgTS);
    
end
   
function addROI(varargin)
    % add rectangles and labels to image plot
	ROIlabels = {'AC','CG','M2','M1','FL','HL','BC','TR','MO','NO','UNa','UNb','S2','PTAa','PTAb','RS','V1','AU','TEA', ...
    'AC','CG','M2','M1','FL','HL','BC','TR','MO','NO','UNa','UNb','S2','PTAa','PTAb','RS','V1','AU','TEA'};
	for i=1:size(RHR,1) 
	  txt_h = text(min(max([RHR(i,1)],1),width), min(max([RHR(i,2)],1),height), ROIlabels(i),'HorizontalAlignment','center','FontSize',9); 
	end
end


end
