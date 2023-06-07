img = imreadalltiff('D:\ChanLab\Data\2021-09-30\HL_R\01_blue_image.tif');

mmPerPixel = 0.01171875; % 12mmx12mm, 1024x1024 pixels -> (12/1024) = 0.01171875
bregmaCoords = [500, 500];
pins = { ...
    {Region.HL_RH, [700, 550]}, ...
    {Region.TEA_RH, [875, 850]}, ...
    {Region.UNa_RH}};

[RHR, RHRlabels] = fitRHR(img, CorticalPrep.Bilateral, bregmaCoords, mmPerPixel, pins);