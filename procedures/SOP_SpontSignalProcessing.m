%% Standardized File Treatment for Spontaneous Intrinsic Signal Processing

%% Spontaneous Intrinsic Signal Processor 2021-03-23 BHope
    % load unprocessed spontaneous activity in .tif format
    % downsample data
    % temporal bandpass filter
    % mask data
    % compute global signal regression
    % calculate dR/R
    % spatial filter
    
    % Create mask on line 51
    % watch for EDIT comments

%% Loading a file

% unprocessed video file (.tif)
% pathname='D:\Brittany Data\2020_11_16 F3\Spont\'; % EDIT
pathname = '/Users/christian/Documents/summer2023/matlab/my_data/';
% filename='12_green_spon_8x8_10hz_9000fr_1.375iso_1t.tif'; % EDIT
filename = '04_awake_8x8_30hz_36500fr.tif';
im0 = imreadalltiff([pathname filename]);
figure_index = 1000;


%% Processing a .tif file

%Dimensions
im0(:,:,end)=[]; % this removes the final extra frame because it must be multiple of 10 to downsample
imheight=size(im0,1); %height
imwidth=size(im0,2); %width
nframes=size(im0,3); %frames

fprintf("imheight = %i\n", imheight);
fprintf("imwidth = %i\n", imwidth)
fprintf("nframes = %i\n", nframes);

% Downsample       
% downfactor=10; % EDIT - downsampling factor you want to use (multiple of 10 - or set as 1 if not downsampling)
downfactor = 1;
im0=reshape(im0,imheight,imwidth,downfactor,nframes/downfactor);
im0=squeeze(mean(im0,3));
nframes=size(im0,3); %frames

fprintf("new nframes = %i\n", nframes);
disp(size(im0))


%% Temporal bandpass filtering
% framerate=10/downfactor; % EDIT - original/downsampling factor = new framerate after downsampling (Hz)
% lowfreqcutoff=0.009; % EDIT - low end frequency cutoff (Hz)
% highfreqcutoff=0.08; % EDIT - low end frequency cutoff (Hz)
framerate=30/downfactor; % EDIT - original/downsampling factor = new framerate after downsampling (Hz)
lowfreqcutoff=10.0; % EDIT - low end frequency cutoff (Hz)
highfreqcutoff=14.999; % EDIT - low end frequency cutoff (Hz)


% Try 0.1 - 5 HZ
% Power spectral density
% Try it 
% symmetrical
% 10 - 15 HZ
% HR: 200-600 BPM
%  - 7-10 HZ
% High pass everything as sanity check
%
% Calculate power spectra of images
% Play around with filter ranges
% Pass through model in MesoNet
%
% If there's distrubarnces in sensory regions,


figure("Name", "Before bandpass")
imagesc(im0(:, :, figure_index)); axis square

im1=imbandpassfilter(im0,nframes,framerate,lowfreqcutoff,highfreqcutoff,0); 
    % uses chebyshev1
    % imbandpassfilter(video,#frames,freq of image aquisition,low pass
    % cutoff freq,high pass cutoff freq,parallelization)
    
figure("Name", "After bandpass")
imagesc(im1(:, :, figure_index)); axis square


%% Make Mask

imstill = imreadalltiff('my_data/01_blue_image.tif'); % EDIT - read in full resolution still image
imstill=imresize(imstill,[imheight imwidth]);

figure("Name", "Create the mask")
imagesc(imstill); axis square
mask=roipoly; % click on all the points around the cortex to make the mask
        % ensure you finish the mask by double clicking on the original point, cursor should be in a circle
mask=double(mask);

imagesc(mask); axis square


%% Global Signal Regression
    % Apply mask first
im1=do_gsr2(im1,mask);

%if you skip this step, remove the tag from the file name below (line 97)


%% Compute delta F/F
del=0;   % EDIT - #frames you want to delete
im1=imdff0(im1,im0,nframes,del);
    % imdff0(img you've worked on, original, #frames,deletion)

figure("Name", "After DF/F0 image")
imagesc(im1(:, :, figure_index)); axis square


%% Gaussian filtering
% sigma=4; % EDIT - kernel size
sigma = 2;
im1=imgaussfilt(im1,sigma);

figure("Name", "Final image")
imagesc(im1(:, :, figure_index)); axis square


%% Save processed file

filenamesave = filename(1:end-4);

% add filename notation for resampling/integration
filenamesave = [filenamesave,'_FR'];
filenamesave = [filenamesave,num2str(framerate)];
filenamesave = [filenamesave,'Hz'];

% add filename notation for filter settings
filenamesave = [filenamesave,'_BPF'];
filenamesave = [filenamesave,num2str(lowfreqcutoff)];
filenamesave = [filenamesave,'-'];
filenamesave = [filenamesave,num2str(highfreqcutoff)];
filenamesave = [filenamesave,'Hz'];
filenamesave = [filenamesave,'_GSR'];

% add filename notation for DFF0 settings
filenamesave = [filenamesave,'_DFF0-G'];
filenamesave = [filenamesave,num2str(sigma)];
filenamesave = [filenamesave, '-fr'];
filenamesave = [filenamesave, num2str(del+1)];
filenamesave = [filenamesave, '-'];
filenamesave = [filenamesave, num2str(nframes+del)];
filenamesave = [filenamesave,'.raw'];

imwriteallraw([pathname filenamesave], im1, 'float32');


% save mask
imwriteallraw([pathname 'mask.raw'],mask,'float32');






