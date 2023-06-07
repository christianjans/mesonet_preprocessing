%% Standardized Unilateral Regional Correlation Processing

%% Spontaneous Intrinsic Regional Correlation Processing 2021-01-28 BHope
    % load processed spontaneous activity in .raw format
    % overlay ROI coordinates
    % generate ROI correlation matrix
    % generate seed pixels for all ROIs
    
    % key variables = corrmatrix1_tril, seedcorr
    % watch for EDIT comments
    
%% Loading a file

%processed video file (.raw)
pathname='C:\Data\2019-12-19_Meso_Intrinsic\'; % EDIT
filename='02_SponGIOS_10Hz_Iso1.25%_~2mmDepth_6000frames_DS1Hz_BPF0.008-0.1Hz_GSR_DFF0-G2-fr1-600.raw'; % EDIT
imheight=256; % EDIT
imwidth=256; % EDIT
nframes=1200; % EDIT
im1 = imreadallraw([pathname filename],imheight,imwidth,nframes,'float32'); 


% read in the mask 
mask=imreadallraw('mask.raw',imheight,imwidth,1,'float32');

% read in the still image
imstill = imreadalltiff('01_GreenImage.tif'); % EDIT - read in full resolution still image

%% Set Bregma and ROI coordinates

prep=1; % unilateral right=1, left=3

[RHR,ROIlabels]=applyROI(imstill,prep,imheight); % Opens GUI, select bregma and press button to Assign Bregma

nRHR=size(RHR,1);


%% Excluding ROIs -- do this if some ROIs fall on the mask

% exRHR=[13,18,19]; % EDIT - list the number for each RHR you'd like to delete
% 
% RHR(exRHR,:)=[];
% ROIlabels(exRHR)=[];
% 
% nRHR=size(RHR,1);
% 
% % Do a visual check of the ROI positions, make sure all outside mask are deleted
% figure(); imagesc(im1(:,:,1)); axis square
% for i=1:nRHR 
%   rectangle('Position',[RHR(i,1)-2.5 RHR(i,2)-2.5 5 5]); text([RHR(i,1)], [RHR(i,2)],ROIlabels(i),'HorizontalAlignment','center'); 
% end


%% ROI correlation matrix

% Cross-correlate ROIs
timecourse=zeros(nframes,nRHR);
for i=1:nRHR
    timecourse(:,i)=MeanFromROI(im1,RHR(i,1),RHR(i,2),10);
end
timecourse=timecourse';


% Unilateral correlation matrix
corrmatrix1=zeros(nRHR,nRHR);
for i=1:nRHR
    for j=1:nRHR
        corrmatrix1(i,j)=corr(timecourse(i,:)',timecourse(j,:)');
    end
end

% Isolate lower triangle and replace 0s with NaNs
corrmatrix1_tril=tril(corrmatrix1);
corrmatrix1_tril(corrmatrix1_tril==0)=NaN;

% Visually check matrix (simple crosscorr)
figure()
heatmap(ROIlabels,ROIlabels,corrmatrix1_tril,'Colormap',jet);



%% Seed pixel maps

im1=reshape(im1,imheight*imwidth,nframes);

for i=1:nRHR
	roiseed(i)=sub2ind([imheight imwidth],RHR(i,2),RHR(i,1));
end
for i=1:nRHR
    parfor j=1:imheight*imwidth
        seedcorr(j,i)=corr(im1(roiseed(i),:)',im1(j,:)');
    end
    i
end

seedcorr=reshape(seedcorr,imheight,imwidth,nRHR); 

figure()
for i=1:nRHR 
    subplot(4,5,i); imagesc(seedcorr(:,:,i)); axis square
    title(ROIlabels(i));
end



%% Save your .m and .mat files

clear im1
save([pathname 'filename.mat']); % EDIT - apply your own filename





