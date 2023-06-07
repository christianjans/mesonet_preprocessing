function  ImageROIMean = MeanFromROI(Image,XUpperLeft,YUpperLeft,ROISize)

step = floor(ROISize/2);
XUpperLeft = floor(XUpperLeft);
YUpperLeft = floor(YUpperLeft);
%X and Y inputs must be reversed and adjusted by 1 elsewhere
roi    = Image(YUpperLeft-step:YUpperLeft + step,XUpperLeft-step:XUpperLeft + step,:);
signal = mean(mean(roi));
signal = double(signal);
ImageROIMean = reshape(signal,1,length(signal));

end