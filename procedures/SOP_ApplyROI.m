%% Standardized ROI Application
    % 2021-01-28 BHope
%% Load imaging video file

%processed video file (.raw)
pathname='C:\Data\2019-12-19_Meso_Intrinsic\'; % EDIT
filename='02_SponGIOS_10Hz_Iso1.25%_~2mmDepth_6000frames_FR1Hz_BPF0.008-0.1Hz_GSR_DFF0-G2-fr1-600.raw'; % EDIT
imheight=256; % EDIT
imwidth=256; % EDIT
nframes=1200; % EDIT
im1 = imreadallraw(filename,imheight,imwidth,nframes,'float32'); 


% read in the mask 
mask=imreadallraw('mask.raw',imheight,imwidth,1,'float32');


%% Overlay ROI coordinates
    % Bilateral first, skip to line 136 if unilateral window

%% Bilateral window

RHR = zeros(38,2);
ROIsize=5;

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

RHR(11,1) = 3.071;          % UNa (X coordinate)    (X,Y)  Unassigned multimodal (anterior portion)
RHR(11,2) = -1.672;         % UNa (Y coordinate)

RHR(12,1) = 3.579;          % UNb (X coordinate)    (X,Y)  Unassigned multimodal (posterior portion)
RHR(12,2) = 2.161;          % UNb (Y coordinate)

RHR(13,1) = 4.645;          % S2 (X coordinate)    (X,Y)  Secondary somatosensory
RHR(13,2) = 0.384;          % S2 (Y coordinate) 

RHR(14,1) = 2.056;          % PTAa (X coordinate)     (X,Y)  Parietal association area (medial)
RHR(14,2) = 2.135;          % PTAa (Y coordinate)

RHR(15,1) = 4.315;          % PTAb (X coordinate)     (X,Y)  Parietal association area (lateral)
RHR(15,2) = 3.176;          % PTAb (Y coordinate)

RHR(16,1) = 0.686;          % RS (X coordinate)    (X,Y)  Retrosplenial
RHR(16,2) = 2.643;          % RS (Y coordinate)

RHR(17,1) = 2.64;           % V1 (X coordinate)    (X,Y)  Primary visual
RHR(17,2) = 3.709;          % V1 (Y coordinate)

RHR(18,1) = 4.619;          % AU (X coordinate)    (X,Y)  Primary auditory
RHR(18,2) = 2.389;          % AU (Y coordinate)

RHR(19,1) = 4.416;          % TEA (X coordinate)   (X,Y)  Temporal association
RHR(19,2) = 3.937;          % TEA (Y coordinate)


RHR(20:38,1)=-1*RHR(1:19,1); % duplicates the RHRs for the other hemisphere
RHR(20:38,2)=RHR(1:19,2);

RHR=RHR*(imheight*0.09375); %convert mm to pixels


ROIlabels = {'rAC','rCG','rM2','rM1','rFL','rHL','rBC','rTR','rMO','rNO','rUNa','rUNb','rS2','rPTAa','rPTAb','rRS','rV1','rAU','rTEA', ...
    'lAC','lCG','lM2','lM1','lFL','lHL','lBC','lTR','lMO','lNO','lUNa','lUNb','lS2','lPTAa','lPTAb','lRS','lV1','lAU','lTEA'};


%% Set Bregma and re-align ROI coordinates

imstill = imreadalltiff('01_GreenImage.tif'); % EDIT - read in full resolution still image
imagesc(imstill); % use data cursor to obtain coordinates for bregma
X = 505; % EDIT - X coordinate
Y = 506; % EDIT - Y coordinate

bregma=[(X/(size(imstill,1)/imheight)) (Y/(size(imstill,1)/imheight))]; % set bregma

RHR=RHR+bregma; % re-align coordinates to bregma

RHR=round(RHR,0); % round to nearest integer

% Do a visual check of the ROI positions
figure(); imagesc(im1(:,:,1));
for i=1:size(RHR) 
  rectangle('Position',[RHR(i,1)-2.5 RHR(i,2)-2.5 5 5]); text([RHR(i,1)], [RHR(i,2)], ROIlabels(i),'HorizontalAlignment','center'); 
end


%% Excluding ROIs -- do this if some ROIs fall on the mask

% exRHR=[13,18,19]; % EDIT - list the number for each RHR you'd like to delete (only right hemisphere)
% 
% RHR(exRHR+19,:)=[]; RHR(exRHR,:)=[];
% ROIlabels(exRHR+19)=[]; ROIlabels(exRHR)=[];
% 
% nRHR=size(RHR,1);
% 
% % Do a visual check of the ROI positions, make sure all outside mask are deleted
% figure(); imagesc(im1(:,:,1));
% for i=1:nRHR 
%   rectangle('Position',[RHR(i,1)-2.5 RHR(i,2)-2.5 5 5]); text([RHR(i,1)], [RHR(i,2)],ROIlabels(i),'HorizontalAlignment','center'); 
% end






%%

%% Unilateral window 
    % default = right hemisphere window

RHR = zeros(19,2);
ROIsize=5;

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

RHR(11,1) = 3.071;          % UNa (X coordinate)    (X,Y)  Unassigned multimodal (anterior portion)
RHR(11,2) = -1.672;         % UNa (Y coordinate)

RHR(12,1) = 3.579;          % UNb (X coordinate)    (X,Y)  Unassigned multimodal (posterior portion)
RHR(12,2) = 2.161;          % UNb (Y coordinate)

RHR(13,1) = 4.645;          % S2 (X coordinate)    (X,Y)  Secondary somatosensory
RHR(13,2) = 0.384;          % S2 (Y coordinate) 

RHR(14,1) = 2.056;          % PTAa (X coordinate)     (X,Y)  Parietal association area (medial)
RHR(14,2) = 2.135;          % PTAa (Y coordinate)

RHR(15,1) = 4.315;          % PTAb (X coordinate)     (X,Y)  Parietal association area (lateral)
RHR(15,2) = 3.176;          % PTAb (Y coordinate)

RHR(16,1) = 0.686;          % RS (X coordinate)    (X,Y)  Retrosplenial
RHR(16,2) = 2.643;          % RS (Y coordinate)

RHR(17,1) = 2.64;           % V1 (X coordinate)    (X,Y)  Primary visual
RHR(17,2) = 3.709;          % V1 (Y coordinate)

RHR(18,1) = 4.619;          % AU (X coordinate)    (X,Y)  Primary auditory
RHR(18,2) = 2.389;          % AU (Y coordinate)

RHR(19,1) = 4.416;          % TEA (X coordinate)   (X,Y)  Temporal association
RHR(19,2) = 3.937;          % TEA (Y coordinate)


RHR=RHR*(imheight*0.09375); %convert mm to pixels


ROIlabels = {'rAC','rCG','rM2','rM1','rFL','rHL','rBC','rTR','rMO','rNO','rUNa','rUNb','rS2','rPTAa','rPTAb','rRS','rV1','rAU','rTEA'}


%% IF LEFT HEMISPHERE WINDOW

RHR(:,1)=-1*RHR(:,1); % reflects the RHRs to the other hemisphere

ROIlabels = {'lAC','lCG','lM2','lM1','lFL','lHL','lBC','lTR','lMO','lNO','lUNa','lUNb','lS2','lPTAa','lPTAb','lRS','lV1','lAU','lTEA'};


%% Set Bregma and re-align ROI coordinates

imstill = imreadalltiff('01_GreenImage.tif'); % EDIT - read in full resolution still image
imagesc(imstill); % use data cursor to obtain coordinates for bregma
X = 505; % EDIT - X coordinate
Y = 506; % EDIT - Y coordinate

bregma=[(X/(size(imstill,1)/imheight)) (Y/(size(imstill,1)/imheight))]; % set bregma

RHR=RHR+bregma; % re-align coordinates to bregma

RHR=round(RHR,0); % round to nearest integer

% Do a visual check of the ROI positions
figure(); imagesc(im1(:,:,1));
for i=1:size(RHR) 
  rectangle('Position',[RHR(i,1)-2.5 RHR(i,2)-2.5 5 5]); text([RHR(i,1)], [RHR(i,2)], ROIlabels(i),'HorizontalAlignment','center'); 
end


%% Excluding ROIs -- do this if some ROIs fall on the mask

% exRHR=[13,18,19]; % EDIT - list the number for each RHR you'd like to delete
% 
% RHR(exRHR,:)=[];
% ROIlabels(exRHR)=[];
% 
% nRHR=size(RHR,1);
% 
% % Do a visual check of the ROI positions, make sure all outside mask are deleted
% figure(); imagesc(im1(:,:,1));
% for i=1:nRHR 
%   rectangle('Position',[RHR(i,1)-2.5 RHR(i,2)-2.5 5 5]); text([RHR(i,1)], [RHR(i,2)],ROIlabels(i),'HorizontalAlignment','center'); 
% end




















%% Vanni Coordinates - RETIRED

% RHR(1,1) = 0.1+0.4;         % AC (X coordinate)    (X,Y)  Anterior cingulate
% RHR(1,2) = -1.875;          % AC (Y coordinate)
% 
% RHR(2,1) = 0.875;           % M2 (X coordinate)    (X,Y)  Secondary motor
% RHR(2,2) = -1.45;           % M2 (Y coordinate)
% 
% RHR(3,1) = 1.9;             % M1 (X coordinate)    (X,Y)  Primary motor
% RHR(3,2) = -0.65;           % M1 (Y coordinate)
% 
% RHR(4,1) = 3.55-0.1;        % MO (X coordinate)    (X,Y)  Mouth
% RHR(4,2) = -0.6;            % MO (Y coordinate)
% 
% RHR(5,1) = 3.875-0.3;       % NO (X coordinate)    (X,Y)  Nose
% RHR(5,2) = 0.475;           % NO (Y coordinate)
% 
% RHR(6,1) = 2.5;             % FL (X coordinate)    (X,Y)  Forelimb
% RHR(6,2) = 0.55;            % FL (Y coordinate)
% 
% RHR(7,1) = 2.825;           % UN (X coordinate)    (X,Y)  Unassigned multimodal
% RHR(7,2) = 0.975;           % UN (Y coordinate)
% 
% RHR(8,1) = 0.35;            % CG (X coordinate)    (X,Y)  Cingulate
% RHR(8,2) = -0.2;            % CG (Y coordinate)
% 
% RHR(9,1) = 1.725;           % HL (X coordinate)    (X,Y)  Hindlimb
% RHR(9,2) = 1.15;            % HL (Y coordinate)
% 
% RHR(10,1) = 4.475;          % S2 (X coordinate)    (X,Y)  Secondary somatosensory
% RHR(10,2) = 1.2;            % S2 (Y coordinate) 
% 
% RHR(11,1) = 3.5;            % BC (X coordinate)    (X,Y)  Barrel cortex
% RHR(11,2) = 1.775;          % BC (Y coordinate)
% 
% RHR(12,1) = 1.9;            % TR (X coordinate)    (X,Y)  Trunk
% RHR(12,2) = 2.025;          % TR (Y coordinate)
% 
% RHR(13,1) = 2.325;          % AA (X coordinate)     (X,Y)  Anterior association area
% RHR(13,2) = 2.5;            % AA (Y coordinate)
% 
% RHR(14,1) = 1.675;          % AM (X coordinate)    (X,Y)  Anteromedial
% RHR(14,2) = 2.7;            % AM (Y coordinate)
% 
% RHR(15,1) = 0.625;          % RS (X coordinate)    (X,Y)  Retrosplenial
% RHR(15,2) = 2.9;            % RS (Y coordinate)
% 
% RHR(16,1) = 3.225;          % RL (X coordinate)    (X,Y)  Rostrolateral
% RHR(16,2) = 2.9;            % RL (Y coordinate)

% RHR(17,1) = 4.6-0.8;        % AU (X coordinate)    (X,Y)  Primary auditory
% RHR(17,2) = 2.95;           % AU (Y coordinate)
% 
% RHR(18,1) = 3.9-0.2;        % AL (X coordinate)    (X,Y)  Anterolateral
% RHR(18,2) = 3.375;          % AL (Y coordinate)
% 
% RHR(19,1) = 1.65;           % PM (X coordinate)    (X,Y)  Posteromedial
% RHR(19,2) = 3.65-0.1;       % PM (Y coordinate)
% 
% RHR(20,1) = 2.55;           % V1 (X coordinate)    (X,Y)  Primary visual
% RHR(20,2) = 4.325;          % V1 (Y coordinate)
% 
% RHR(21,1) = 4.15;           % LI (X coordinate)    (X,Y)  Lateralintermediate
% RHR(21,2) = 4.275;          % LI (Y coordinate)
% 
% RHR(22,1) = 4.65;           % TEA (X coordinate)   (X,Y)  Temporal association
% RHR(22,2) = 4.275;          % TEA (Y coordinate)
% 
% RHR(23,1) = 3.775;          % LM (X coordinate)    (X,Y)  Lateralmedial
% RHR(23,2) = 4.325;          % LM (Y coordinate)
% 
% RHR(24,1) = 4.3;            % POR (X coordinate)   (X,Y)  Postrhinal
% RHR(24,2) = 4.8;            % POR (Y coordinate)
% 
% RHR(25,1) = 3.575;          % PL (X coordinate)    (X,Y)  Posterolateral
% RHR(25,2) = 5.3;            % PL (Y coordinate)
% 
% 
% RHR=RHR*(imheight*0.09375); %convert mm to pixels
% 
% 
% ROIlabels = {'rAC','rM2','rM1','rMO','rNO','rFL','rUN','rCG','rHL','rS2','rBC','rTR','rAA','rAM','rRS','rRL','rAU','rAL','rPM','rV1','rLI','rTEA','rLM','rPOR','rPL'};
