function zcourse(img_in)
    % img_in is a 3D matrix
    % create a line plot of values across the third dimension based on ROI
    % specificed by mouse-click input

    l=size(img_in,1);
    w=size(img_in,2);
    z=size(img_in,3);
    
    imagesc(img_in(:,:,1))
    [y,x]=ginput(1); % note the order
    x=round(x);
    y=round(y);
    figure();
    zcourse=(img_in(x,y,:));
    zcourse=squeeze(zcourse);
    plot(zcourse);
end
