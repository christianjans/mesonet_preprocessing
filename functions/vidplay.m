function vidplay(x)
    % quick 3D matrix video play
    % auto scale using pixelwise mean +/- 3 SDs
    % video step size default is 3 frames
    %
    % modified January 18, 2017
    
    h=size(x,1);
    w=size(x,2);
    z=size(x,3);
    
    % autoscale color range to pixelwise mean +/- 3 SDs
    % note: no accommodation for presence of mask
    t1=reshape(x,1,h*w*z);
    % downsample for speed based on number of frames
    if z > 100000 
        t1=downsample(t1,50); 
    elseif z <= 100000 && z >= 30000
        t1=downsample(t1,25);
    else
        t1=t1;
    end
    
    m1=mean(t1);
    fivesig=5*std(t1);
    c=[(m1-fivesig) (m1+fivesig)];
            
    fr=1; % initial frame
    ssize=2;  % next frame step size
    for i=1:z        
        imagesc(x(:,:,fr), c);axis off;colorbar;title(['frame number: ' num2str(fr)]);colormap(viridis);
        pause(0.1);
        fr=fr+ssize;
        if fr > z
            break;
        end                   
    end
     
end
