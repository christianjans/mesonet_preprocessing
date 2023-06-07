function A=lohinoproc(im1, bframes, f)
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
    for a=1:size(im1,5) % 3 states: lo, hi, no
        for b=1:size(im1,4) % trial number
            for c=1:size(im1,3) % frame number
                im1(:,:,c,b,a)=imgaussfilt(im1(:,:,c,b,a),1);
            end
        end
    end
else
    % do nothing
end
              

nframes=size(im1,3);
trialnum=size(im1,4);
imdelta=zeros(size(im1,1),size(im1,1),nframes,trialnum*2);
ind=1;

for i=1:trialnum; % number of trials
    
    for j=1:nframes; % number of frames (time course)
        imdelta(:,:,j,ind)=im1(:,:,j,i,1)./im1(:,:,j,i,3);  %load and norm lo to no 
        imdelta(:,:,j,ind+1)=im1(:,:,j,i,2)./im1(:,:,j,i,3); %load and norm hi to no 
    end
    
    prestim_lo=squeeze(squeeze(mean(imdelta(:,:,bframes(1,1):bframes(1,2),ind),3)));  % baseline region from frames fr1-fr2
    prestim_hi=squeeze(squeeze(mean(imdelta(:,:,bframes(1,1):bframes(1,2),ind+1),3))); % baseline region from frames fr1-fr2
    
    for k=1:nframes; % divide by immediate pre-stim baseline
        imdelta(:,:,k,ind)=imdelta(:,:,k,ind)./prestim_lo;
        imdelta(:,:,k,ind+1)=imdelta(:,:,k,ind+1)./prestim_hi;
    end
    
    ind=ind+2; 
    prestim_lo=0;
    prestim_hi=0;
end

imdelta=(imdelta-1.)*100.;  % convert to %
A=imdelta;
clear imdelta;
end