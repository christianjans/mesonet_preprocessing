%% Intrinsic Signal Processor
    % 2021-01-19 BHope
	% This code is specifically for bilateral preps.

%% load individual stimulus trials
path1='D:\Ryan\2020-03-19 Urethane\Auditory_R\';	%set path to the folder containing all the trials
ntrials=40;
im1=imreadlo(path1,ntrials);

imwidth=256;
imheight=256;
nframes=201;

% set the ROI # that was targeted during this stimulation trial
	% make sure you are targeting the correct hemisphere
ROI=37;		% HL=6, so if HL_R trial, add 19 to get 25 for left hemisphere
% FL=5; HL=6; BC=7; S2=13; V1=17; AU=18


%% If V1 - remove light flash

im2=im1;
for i=1:ntrials
    im2(:,:,29,i)=im1(:,:,28,i);
    im2(:,:,30,i)=im1(:,:,28,i);
end



%% Set Bregma and ROI coordinates

imstill = imreadalltiff('20_red_image.tif'); % EDIT - read in full resolution still image
prep=2; % bilateral=2, unilateral right=1, unilateral left=3

[RHR,ROIlabels]=applyROI(imstill,prep,imheight); % Opens GUI, select bregma and press button to Assign Bregma

nRHR=size(RHR,1);


%% Compute deltaR/R

bframes=[1 28];  % set baseline frames
im2=imloproc(im1, bframes, 1); % 

%% GSR - must also create mask

imstill=imresize(imstill,[256 256]);

figure()
imagesc(imstill); axis square
mask=roipoly; % click on all the points around the cortex to make the mask
        % ensure you finish the mask by double clicking on the original point, cursor should be in a circle
mask=double(mask);

imagesc(mask); axis square

% Global Signal Regression
for i=1:ntrials
   im2(:,:,:,i)=do_gsr2(im2(:,:,:,i),mask);
end


%% Check for 'bad' trials
		% use this if you'd like to check for any bad trials and remove them
% 
% for i=1:40
%     subplot(4,10,i);
%     plot(timecourse(:,i,ROI));
% end
% 
% % remove 'bad' trials
% badtrials=[3,8,19,25,28,29,31,40]; %trial numbers that are bad - to remove
% 
% im2(:,:,:,badtrials)=[];
% 
% ntrials=ntrials-size(badtrials,2);
% 

%% Remove slope

% Find timecourse for each trial and ROI
for j=1:nRHR
    for i=1:ntrials
        timecourse(:,i,j)=MeanFromROI(im2(:,:,:,i), RHR(j,1), RHR(j,2), 10);
    end
    j
end

x=(1:1:201)'; %x=nframes
for j=1:nRHR
    for i=1:ntrials
        abfit{i,j}=polyfit(x,timecourse(:,i,j),1);
        slopefit(:,i,j)=polyval(abfit{i,j},x);
        adjtimecourse(:,i,j)=timecourse(:,i,j)-slopefit(:,i,j);
    end
end

% figure() % compare original to adjusted trials for ROI
% for i=1:ntrials 
%     subplot(4,10,i); plot(timecourse(:,i,ROI)); ylim([-0.6 0.6]); hold on
%     plot(adjtimecourse(:,i,ROI));
% end


%% Reset baseline (post removing slope)

for j=1:nRHR
    for i=1:ntrials
        basemean(i,j)=mean(adjtimecourse(1:25,i,j));
        TC2(:,i,j)=adjtimecourse(:,i,j)-basemean(i,j);
    end
end

% figure() % compare original to adjusted trials for ROI
% for i=1:ntrials
%     subplot(4,10,i); plot(adjtimecourse(:,i,ROI)); ylim([-0.6 0.6]); hold on
% 	plot(TC2(:,i,ROI)); ylim([-0.6 0.6]);
% end


%% Smoothing (post-slope removal and baseline reset)

for j=1:nRHR
    for i=1:ntrials
        TC3(:,i,j)=smooth(TC2(:,i,j),'moving');
    end
end

% figure() %only looking at FL trials to compare adjusted
% for i=1:ntrials
%     subplot(4,10,i);  plot(TC2(:,i,ROI)); ylim([-0.6 0.6]); hold on
% 	plot(TC3(:,i,ROI)); ylim([-0.6 0.6]);
% end



%% Finding means of all trials

timecourseM=squeeze(mean(timecourse,2)); %unprocessed
adjtimecourseM=squeeze(mean(adjtimecourse,2)); %slope-removed
TC2M=squeeze(mean(TC2,2)); %baseline reset
TC3M=squeeze(mean(TC3,2)); %smoothed

timecourseSEM=squeeze(std(timecourse,0,2)/sqrt(ntrials));
adjtimecourseSEM=squeeze(std(adjtimecourse,0,2)/sqrt(ntrials));
TC2SEM=squeeze(std(TC2,0,2)/sqrt(ntrials));
TC3SEM=squeeze(std(TC3,0,2)/sqrt(ntrials));


%% Figure to show the change after each step

F=(1:200); %took off last frame to make viewing easier
figure() 
subplot(1,4,1); shadedErrorBar(F,timecourseM(F,ROI),timecourseSEM(F,ROI)); ylim([-0.1 0.15]); title('Normal');
subplot(1,4,2); shadedErrorBar(F,adjtimecourseM(F,ROI),adjtimecourseSEM(F,ROI)); ylim([-0.1 0.15]); title('Slope-adjusted');
subplot(1,4,3); shadedErrorBar(F,TC2M(F,ROI),TC2SEM(F,ROI)); ylim([-0.1 0.15]); title('Baseline adjusted');
subplot(1,4,4); shadedErrorBar(F,TC3M(F,ROI),TC3SEM(F,ROI)); ylim([-0.1 0.15]); title('Smoothed');
line([28,28],[-0.1,0.15],'LineStyle',':');



%% To see the cortical representation of this activity

imMean=mean(im2,4);

evoked=mean(imMean(:,:,30:60),3);

figure()
imagesc(evoked); title('Initial Dip'); axis square
rectangle('Position',[RHR(ROI,1)-5 RHR(ROI,2)-5 10 10]);

figure()
subplot(1,2,1); shadedErrorBar(F,TC3M(F,ROI),TC3SEM(F,ROI)); ylim([-0.15 0.1]); title('Smoothed'); line([29,29],[-0.15,0.20],'LineStyle',':');
subplot(1,2,2); imagesc(evoked); title('Evoked (Frames 30:120)'); axis square
rectangle('Position',[RHR(ROI,1)-5 RHR(ROI,2)-5 10 10]);
suptitle('HL');



save('HL_R.mat','-v7.3');






