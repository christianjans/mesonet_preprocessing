%  Modified from Matthieu's "OIA_wfi_load_simple.m"
%  Added parameter for optional parallelized loading
%  if you want to use "for", do not include 'par' parameter
%  if you want to use "parfor", par = 1
% 
%  Modified 2016-09-02
%  Modified 2017-01-18:  if nargin < 2, than do not use parfor by default
%  Modified 2017-11-30:  corrected syntax such that no 'par' parameter defaults to no parfor

function M = imreadalltiff(file, par)
    % debug
%     nargin
    % default to not use parfor if not explicitly specified
    if nargin < 2
        par = 0;
    else
        par = 1;
    end

    info = imfinfo(file);
    tampon = imread(file,'Index',1);
    F = length(info);
%     M = zeros(size(tampon,1),size(tampon,2),F,'uint16');
    M = zeros(size(tampon,1),size(tampon,2),F,'double');
    M(:,:,1) = tampon(:,:,1);
    tic
    ind = 0;
    if par==1; % use parfor
        disp(' ');
        disp('Loading...');
        parfor i = 2:F
            tampon = imread(file,'Index',i,'Info',info);
            M(:,:,i) = tampon(:,:,1);
        end
        disp('Loading... completed.');       
    else % Matthieu's original loading loop        
        wait_bar = waitbar(0,'open file');
        for i = 2:F
            if ind == 0, waitbar(i/F, wait_bar); end;
            ind = ind + 1; if ind == 100, ind = 0; end;
            tampon = imread(file,'Index',i,'Info',info);
            M(:,:,i) = tampon(:,:,1);
        end;   
        close(wait_bar);
        temps = num2str(round(10*toc)/10);
        disp([file ' open in ' num2str(temps) 's'])        
    end