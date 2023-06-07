%% Mask Creation  -  2020-01-28 BHope

%% Imaging video file

pathname='C:\Data\2019-12-19_Meso_Intrinsic\'; % EDIT
filename='02_SponGIOS_10Hz_Iso1.25%_~2mmDepth_6000frames.tif'; % EDIT

%if tiff
im1 = imreadalltiff([pathname filename]); 
%if raw
im1 = imreadallraw([pathname filename],128,128,600,'float32'); % EDIT - imheight,imwidth,nframes

%% Draw ROI

imstill = imreadalltiff('01_GreenImage.tif'); % EDIT - read in full resolution still image
imagesc(imstill); 
imstill=imresize(imstill,[size(im0,1) size(im0,2)]);

% Single bilateral mask
figure()
imagesc(imstill);
mask=roipoly; % click on all the points around the cortex to make the mask
        % ensure you finish the mask by double clicking on the original point, cursor should be in a circle
mask=double(mask);
        
imagesc(mask);


% Double bilateral mask
%   left hemisphere
figure()
imagesc(imstill);
maskl=roipoly; % select only points around left hemisphere
maskl=double(maskl);

%   right hemisphere
figure()
imagesc(imstill);
maskr=roipoly; % select only points around right hemisphere
maskr=double(maskr);

masklr=maskl+maskr;
imagesc(masklr);


%% Apply mask to verify
im1=im1.*mask;
vidplay(im1);


%% Save mask
imwriteallraw([pathname 'mask.raw'],mask,'float32');


