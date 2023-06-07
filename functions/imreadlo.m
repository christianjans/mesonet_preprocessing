function [A]=imreadlo(path1, ntrials)

% stupid function to read trial-evoked activity using the convention: lo, hi, no
% path1 is where the lo,hi,no tifs are located
% ntrials is the number of trials 
% images are loaded in a 5D matrix in the form of:
% height, width, frame number, trial number, stimulus state (eg. lo/hi/no)
% NOTE:  loading sequence is "lo" then "hi" then "no"
%
% Modified 2016-09-19                                                       %% different? All comments wrong

for i = 1:ntrials
	im1(:,:,:,i)=imreadalltiff([path1 'lo' num2str(i) '.tif']);

A=im1;
clear im;

end

