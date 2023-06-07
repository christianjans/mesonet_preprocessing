% pixel-wise straight line subtraction to correct for linear drift in pixel intensity across frames/time
% normalization of pixel intensity timecourse by subtraction of fit straight lines 
%
% Last edit March 14, 2020 (AWC)

im2=zeros(size(im1,1)*size(im1,2),size(im1,3),size(im1,4));  % create a container variable to house line-subtracted images
im1=reshape(im1,size(im1,1)*size(im1,2),size(im1,3),size(im1,4));
npixels=size(im1,1);
linepoint=[];

tic
for j=1:size(im1,3); % number of trials
    linepoint(:,1)=mean(im1(:,20:30,j),2); % determine index of start points of line for all pixels, average of frames 20-30 
    linepoint(:,2)=mean(im1(:,end-10:end,j),2); % determine index end points of line for all pixels, average of frames last 20 frames 
    % note: slicing variable, linepoint, with temporary variables does not increase processing speed
    disp(['trial ' num2str(j)]); 
    for i=1:npixels        
        coefficients = polyfit([1,201], [linepoint(i,1), linepoint(i,2)],1);  % compute line coefficients to two points (start at 1 and end at frame 201)
        baseline=coefficients(1,1)*(1:1:201)+coefficients(1,2); % create line comprised of 201 time points for each pixel
        im2(i,:,j)=(im1(i,:,j)-baseline)+linepoint(i,1); % subtract line and re-normalize with start point values
    end
end

