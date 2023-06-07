function [RHR,ROIlabels,bregma] = applyROI(imstill,prep,imheight)

% 2020-06-02 BHope
	% Used for creating RHR coordinates
	% imstill is the full resolution still image taken immediately before recording
	% prep is the window preparation. 1=unilateral right; 2=bilateral; 3=unilateral left
	% imheight is the size of the recording, usually 256
	% TO USE: once figure opens, click on where you think bregma is. Once happy with selection, press button to assign 
		% coordinates for subsequent calculations

	%% Set Bregma and re-align ROI coordinates

image_h = imagesc(imstill); axis square % open figure of still image to allow bregma selection

dcm=datacursormode;	% sets the data cursor to display info in the corner
dcm.Enable= 'on';
dcm.DisplayStyle = 'window';

% add UI button for selecting bregma
bregma_h = uicontrol('Style', 'Pushbutton', ...
    'String',['Assign Bregma'], ...
    'Units','Normalized',...
    'Position', [0.2,0.95,0.3,0.04],...
    'Callback', @GetBregma,... 
    'ForegroundColor','k'); 


uiwait;	% added this because the parent function was executing before the button was pushed
function coord = GetBregma(varargin)
	Selection = getCursorInfo(dcm);
	coord = Selection.Position;
	close all	% tried close image_h but it didn't close


%% Regions of Interest Coordinates

if prep==2
	RHR = zeros(38,2);
else 
	RHR = zeros(19,2);
end

RHR(1,1) = 0.356;           % AC (X coordinate)    (X,Y)  Anterior cingulate
RHR(1,2) = -1.85;           % AC (Y coordinate)

RHR(2,1) = 0.356;           % CG (X coordinate)    (X,Y)  Cingulate
RHR(2,2) = 0.438;           % CG (Y coordinate)

RHR(3,1) = 0.635;           % M2 (X coordinate)    (X,Y)  Secondary motor
RHR(3,2) = -0.936;          % M2 (Y coordinate)

RHR(4,1) = 1.549;           % M1 (X coordinate)    (X,Y)  Primary motor
RHR(4,2) = -0.758;          % M1 (Y coordinate)

RHR(5,1) = 2.767;           % FL (X coordinate)    (X,Y)  Forelimb
RHR(5,2) = -0.276;          % FL (Y coordinate)

RHR(6,1) = 1.853;           % HL (X coordinate)    (X,Y)  Hindlimb
RHR(6,2) = 0.333;           % HL (Y coordinate)

RHR(7,1) = 3.883;           % BC (X coordinate)    (X,Y)  Barrel cortex
RHR(7,2) = 0.765;           % BC (Y coordinate)

RHR(8,1) = 2.31;            % TR (X coordinate)    (X,Y)  Trunk
RHR(8,2) = 1.247;           % TR (Y coordinate)

RHR(9,1) = 3.325;           % MO (X coordinate)    (X,Y)  Mouth
RHR(9,2) = -1.088;          % MO (Y coordinate)

RHR(10,1) = 4.036;          % NO (X coordinate)    (X,Y)  Nose
RHR(10,2) = -0.809;         % NO (Y coordinate)

RHR(11,1) = 3.071;          % UNa (X coordinate)   (X,Y)  Unassigned multimodal (anterior portion)
RHR(11,2) = -1.672;         % UNa (Y coordinate)

RHR(12,1) = 3.579;          % UNb (X coordinate)   (X,Y)  Unassigned multimodal (posterior portion)
RHR(12,2) = 2.161;          % UNb (Y coordinate)

RHR(13,1) = 4.645;          % S2 (X coordinate)    (X,Y)  Secondary somatosensory
RHR(13,2) = 0.384;          % S2 (Y coordinate) 

RHR(14,1) = 2.056;          % PTAa (X coordinate)  (X,Y)  Parietal association area (medial)
RHR(14,2) = 2.135;          % PTAa (Y coordinate)

RHR(15,1) = 4.315;          % PTAb (X coordinate)  (X,Y)  Parietal association area (lateral)
RHR(15,2) = 3.176;          % PTAb (Y coordinate)

RHR(16,1) = 0.686;          % RS (X coordinate)    (X,Y)  Retrosplenial
RHR(16,2) = 2.643;          % RS (Y coordinate)

RHR(17,1) = 2.64;           % V1 (X coordinate)    (X,Y)  Primary visual
RHR(17,2) = 3.709;          % V1 (Y coordinate)

RHR(18,1) = 4.619;          % AU (X coordinate)    (X,Y)  Primary auditory
RHR(18,2) = 2.389;          % AU (Y coordinate)

RHR(19,1) = 4.416;          % TEA (X coordinate)   (X,Y)  Temporal association
RHR(19,2) = 3.937;          % TEA (Y coordinate)



if prep==2 %bilateral
	RHR(20:38,1)=-1*RHR(1:19,1); % duplicates the RHRs for the other hemisphere
	RHR(20:38,2)=RHR(1:19,2);

	ROIlabels = {'rAC','rCG','rM2','rM1','rFL','rHL','rBC','rTR','rMO','rNO','rUNa','rUNb','rS2','rPTAa','rPTAb','rRS','rV1','rAU','rTEA', ...
	'lAC','lCG','lM2','lM1','lFL','lHL','lBC','lTR','lMO','lNO','lUNa','lUNb','lS2','lPTAa','lPTAb','lRS','lV1','lAU','lTEA'};
else %unilateral
	ROIlabels = {'AC','CG','M2','M1','FL','HL','BC','TR','MO','NO','UNa','UNb','S2','PTAa','PTAb','RS','V1','AU','TEA'};
end


if prep==3 %left hemisphere prep (1=right hemi)
	RHR(:,1)=-1*RHR(:,1); % reflects the RHRs to the other hemisphere
end	


RHR=RHR*(imheight*0.09375); %convert mm to pixels

X = coord(1); % X coordinate assigned by button press
Y = coord(2); % Y coordinate assigned by button press

bregma=[(X/(size(imstill,1)/imheight)) (Y/(size(imstill,1)/imheight))]; % set bregma coordinates within smaller scale image

RHR=RHR+bregma; % re-align ROI coordinates to bregma

% % For older versions of MATLAB to re-align ROI coordinates to bregma
% RHR(:,1)=RHR(:,1)+bregma(1);  % X coords
% RHR(:,2)=RHR(:,2)+bregma(2);  % Y coords

RHR=round(RHR,0); % round to nearest integer

end

% visualize ROI placement
figure(); imagesc(imresize(imstill,[imheight imheight])); axis square
for i=1:size(RHR) 
  rectangle('Position',[RHR(i,1)-5 RHR(i,2)-5 10 10]); text([RHR(i,1)], [RHR(i,2)], ROIlabels(i),'HorizontalAlignment','center'); 
end


end

