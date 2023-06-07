function [A]=imbandpassfilter(img, nFrames,FR,Lowpasscutoff,Highpasscutoff, par)
%nFrames=number of frames; FR=frequency of image acquisition;
%Lowpasscutoff=freq. in Hz (eg. 0.002Hz); Highpasscutt=freq in Hz (eg.
%0.1Hz); img is image to filtered
%
% Modified to add option for parallelized filtering for large files
% use parfor, par ==1;
% use for, par ~= 1;
% 
% modified 2016-09-06

width = size(img,1);
height = size(img,2);
s = width*height;
framenum=nFrames;

img = reshape(double(img),s,framenum);

Nyquist = FR/2;    
Bandpass = [Lowpasscutoff Highpasscutoff]/Nyquist;
FILTERORDER = 4;
[z,p,k] = cheby1(FILTERORDER,0.1,Bandpass); %bandpass gives you 0 mean
[sos,g]=zp2sos(z,p,k);

if par==1 % Use parfor
    disp(' ');
    disp('Two-way Chebyshev bandpass filtering...');
    parfor i = 1:s % filter every pixel (s) in time (columns of img)
        img(i,:) = filtfilt(sos,g,img(i,:));
    end
    disp('Two-way Chebyshev bandpass filtering... completed.');
else    % Use for
    wait_bar = waitbar(0,'Two-way Chebyshev bandpass filtering...');
    for i = 1:s
        img(i,:) = filtfilt(sos,g,img(i,:));
        waitbar(i/s, wait_bar);
    end
    close(wait_bar);
end

img = reshape(img,width,height,framenum);
A=img;

clear img;

