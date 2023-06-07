pathname='/Users/christian/Documents/summer2023/matlab/my_data/'; % EDIT
% filename='04_awake_8x8_30hz_36500fr_FR3Hz_BPF0.1-1Hz_GSR_DFF0-G2-fr1-3650.raw'; % EDIT
filename='mask.raw'; % EDIT
imheight=128; % EDIT
imwidth=128; % EDIT
nframes=1; % EDIT
im_raw = imreadallraw([pathname filename],imheight,imwidth,nframes,'float32');

figure_index = 1;
figure("Name", "Raw Image")
imagesc(im_raw(:, :, figure_index)); axis square
% figure("Name", "Raw Image 2")
% imagesc(im_raw(:, :, figure_index + 3649)); axis square
