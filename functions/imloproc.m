function A=imloproc(im1, bframes, f)
% im1 is the input from 'imreadlohino'
% bframes is the baseline frame range (eg. bframes=[25 30], 25-30th frame)
% f=1, to Gaussian filter images individually

% this assumes hi and lo are the same type of stimulus (does keep them separate)
% resultant matrix eliminates 5th dim and orders 4th as norm. lo, hi, lo, hi etc.
% gaussian sigma value is 1
% 
% output is 4D matrix of height:width:nframes:trialnum

% Gaussian filter
if f==1
    for i=1:size(im1,4)
        im1(:,:,:,i)=imgaussfilt(im1(:,:,:,i),2);
    end
    
else
    % do nothing
end
              
nframes=size(im1,3);
trialnum=size(im1,4);
imdelta=zeros(size(im1,1),size(im1,2),nframes,trialnum);
ind=1;

for i=1:trialnum % number of trials
    prestim_base=im1(:,:,bframes(1):bframes(2),i);
    prestim_base=mean(prestim_base,3);
    for j=1:nframes
        imdelta(:,:,j,i)=((im1(:,:,j,i)-prestim_base)./prestim_base)*100;
    end
end

A=imdelta;
end