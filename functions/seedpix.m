function [seedmap] = seedpix(video,xcoordinate,ycoordinate)
% Mar 12,2020 - BHope
% fxn for creating seed pixel maps
% video must be 3D shape

imheight=size(video,1);
imwidth=size(video,2);
nframes=size(video,3);

video=reshape(video,imheight*imwidth,nframes);

roiseed=sub2ind([imheight imwidth],ycoordinate,xcoordinate); %creating linear coordinates 

for i=1:imheight*imwidth %can use parfor
    seedmap(i)=corr(video(roiseed,:)',video(i,:)'); 
end

seedmap=reshape(seedmap,imheight,imwidth); 

end

