%% Standardized Bilateral Regional Correlation Processing

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
filename='02_SponGIOS_10Hz_Iso1.25%_~2mmDepth_6000frames_FR1Hz_BPF0.008-0.1Hz_GSR_DFF0-G2-fr1-600.raw'; % EDIT
imheight=256; % EDIT
imwidth=256; % EDIT
nframes=1200; % EDIT

im1 = imreadallraw([pathname filename],imheight,imwidth,nframes,'float32'); 

% read in the mask 
mask=imreadallraw('mask.raw',imheight,imwidth,1,'float32');

% read in the still image
imstill = imreadalltiff('01_green_image.tif'); % EDIT - read in full resolution still image

%% Set Bregma and ROI coordinates

prep=2; % bilateral=2

[RHR,ROIlabels]=applyROI(imstill,prep,imheight); % Opens GUI, select bregma and press button to Assign Bregma

nRHR=size(RHR,1);


%% Excluding ROIs -- do this if some ROIs fall on the mask

% exRHR=[13,18,19]; % EDIT - list the number for each RHR you'd like to delete (only right hemisphere)
% 
% RHR(exRHR+19,:)=[]; RHR(exRHR,:)=[];
% ROIlabels(exRHR+19)=[]; ROIlabels(exRHR)=[];
% 
% nRHR=size(RHR,1);
% 
% % Do a visual check of the ROI positions, make sure all outside mask are deleted
% figure(); imagesc(im1(:,:,1)); axis square
% for i=1:nRHR 
%   rectangle('Position',[RHR(i,1)-5 RHR(i,2)-5 10 10]); text([RHR(i,1)], [RHR(i,2)],ROIlabels(i),'HorizontalAlignment','center'); 
% end


%% ROI correlation matrix

% Cross-correlate ROIs
timecourse=zeros(nframes,nRHR);
for i=1:nRHR
    timecourse(:,i)=MeanFromROI(im1,RHR(i,1),RHR(i,2),10);
end
timecourse=timecourse';


% Unilateral correlation matrix - Right
corrmatrix1R=zeros(nRHR/2,nRHR/2);
for i=1:(nRHR/2)
    for j=1:(nRHR/2)
        corrmatrix1R(i,j)=corr(timecourse(i,:)',timecourse(j,:)');
    end
end
% Isolate lower triangle and replace 0s with NaNs
corrmatrix1R_tril=tril(corrmatrix1R);
corrmatrix1R_tril(corrmatrix1R_tril==0)=NaN;
% Visually check matrix (simple crosscorr)
figure()
heatmap(ROIlabels(1:nRHR/2),ROIlabels(1:nRHR/2),corrmatrix1R_tril,'Colormap',jet);



    % Left
corrmatrix1L=zeros(nRHR/2,nRHR/2);
for i=1:(nRHR/2)
    for j=1:(nRHR/2)
        corrmatrix1L(i,j)=corr(timecourse(i+(nRHR/2),:)',timecourse(j+(nRHR/2),:)');
    end
end
% Isolate lower triangle and replace 0s with NaNs
corrmatrix1L_tril=tril(corrmatrix1L);
corrmatrix1L_tril(corrmatrix1L_tril==0)=NaN;
% Visually check matrix (simple crosscorr)
figure()
heatmap(ROIlabels(1+nRHR/2:nRHR),ROIlabels(1+nRHR/2:nRHR),corrmatrix1L_tril,'Colormap',jet);



% Bilateral correlation matrix
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


% Compare all
figure()
subplot(1,3,1);
heatmap(ROIlabels(1:nRHR/2),ROIlabels(1:nRHR/2),corrmatrix1R_tril,'Colormap',jet);
subplot(1,3,2);
heatmap(ROIlabels(1+nRHR/2:nRHR),ROIlabels(1+nRHR/2:nRHR),corrmatrix1L_tril,'Colormap',jet);
subplot(1,3,3);
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
    subplot(5,8,i); imagesc(seedcorr(:,:,i)); axis square 
    title(ROIlabels(i));
end


%% Save your .m and .mat files

clear im1
save([pathname 'filename.mat']); % EDIT - apply your own filename


%% Hemispheric seed pixel similarity -- still in development

% timecourse=timecourse';
% 
% for i=1:nRHR/2
%         hemicorr(:,i)=corr(timecourse(:,i),timecourse(:,i+nRHR/2));
% end
% 
% figure()
% RHRlabels = {'AC','CG','M2','M1','FL','HL','BC','TR','MO','NO','UNa','UNb','S2','PTAa','PTAb','RS','V1','AU','TEA'};
% bar(hemicorr);
% xlabel('ROI'); xticks(1:19); set(gca,'xticklabel',RHRlabels); xtickangle(45);
% 
% 
% % Grouped
% 
% gstrength(1)=mean(hemicorr([3,4]),2); %motor
% gstrength(2)=mean(hemicorr([5,6,7,8,9,10,11,12,13]),2); %somatosensory
% gstrength(3)=mean(hemicorr([1,2,16]),2); %DMN
% gstrength(4)=hemicorr([17]); %visual
% gstrength(5)=mean(hemicorr([18,19]),2); %auditory
% gstrength(6)=mean(hemicorr([14,15]),2); %PTA
% 
% gstrengthsd(1)=std(hemicorr([3,4])); %motor
% gstrengthsd(2)=std(hemicorr([5,6,7,8,9,10,11,12,13])); %somatosensory
% gstrengthsd(3)=std(hemicorr([1,2,16])); %DMN
% gstrengthsd(4)=std([17]); %visual
% gstrengthsd(5)=std(hemicorr([18,19])); %auditory
% gstrengthsd(6)=std(hemicorr([14,15])); %PTA
% 
% 
% figure()
% bar(gstrength); hold on
% errorbar(1:6,gstrength,-gstrengthsd,gstrengthsd,'Color',[0 0 0],'LineStyle','none');
% set(gca,'xticklabel',{'Motor' 'Somatosensory' 'DMN' 'Visual' 'Auditory' 'PTA'});
% 
% 
% 
% % Symmetry
% seedcorr=reshape(seedcorr,128*128,38);
% for i=1:nRHR/2
% 	Symmetry(:,i) = 1-abs(seedcorr(:,:,i)-seedcorr(:,:,i+19))/seedcorr(:,:,i) * 100
% end






