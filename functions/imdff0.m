function [A]=imdff0(img_in, raw_img, nFrames,del)
% 
% img_in = images on which to computer dff0 (typically bandpass filtered)
% raw_img = raw images "img_in" from which to compute DC frame
% nFrames = number of frames
% del = number of frames to delete from the beginning of video% (filt)
%
% Note:  using parfor for these operations does not increase speed
% Modified 2020-01-13 BHope

% Delete initial segment of video containing filter artifact 
img_in = img_in(:,:,(del+1):nFrames);
dcframe = mean(raw_img(:,:,del+1:nFrames),3);

% adjust frame count following frame deletion
nFrames=size(img_in, 3);
  
% Add normalizing frame (renormalize image to pre-filter grey values)
im1=zeros(size(img_in,1),size(img_in,2),nFrames);
im1=img_in+dcframe;


% Compute F0 (immean)
immean=mean(im1,3);

% DeltaF/F0*100%
wait_bar = waitbar(0,'Computing DF/F0...');
for i = 1:nFrames
      im1(:,:,i)=((im1(:,:,i)-immean)./immean)*100;
      waitbar(i/nFrames, wait_bar);
end
close(wait_bar);

A=im1;
