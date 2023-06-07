% tiff combiner
% procedure to combine sequence of .tif files when Ryan accidentally saves (tens of) thousands of individual files ;) 
% 
% Last edit March 14, 2020 (AWC)  

% get structure of directory containing .TIF files
path='';  % path containing images
files=dir(path);

% extract image filenames from directory structure
nfiles=3600;  % number of files to combine
filenames=[];
filenames=string(filenames);
ind=4; % filenames start at row 4
for i=1:nfiles
    filenames(:,i)=files(ind).name;
    ind=ind+1;
end
filenames=filenames';

% load individual images
for i=1:nfiles
    imcombined(:,:,i)=imreadalltiff([filenames(i)]);
end

fname='02_green_4x4_1Hz_3600fr_1.25iso.raw';
imwriteallraw(fname, imcombined, 'float32');