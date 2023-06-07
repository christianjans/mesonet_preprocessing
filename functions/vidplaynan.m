function vidplaynan(x)
    % quick 3D matrix video play
    % auto scale using pixelwise mean +/- 5 SDs
    % video step size default is 3 frames
    %
    % modified from vidplay.m to recognize and disregard NaNs 
    %
    % modified April 18, 2017
    
    tmp1=x(:,:,1);
    ind=isnan(tmp1); % find pixels outside mask
    ind2=find(ind==0); % find pixels within mask
    
    h=size(x,1);
    w=size(x,2);
    z=size(x,3);
    
    % autoscale color range to pixelwise mean +/- 3 SDs
    % note: no accommodation for presence of mask
    
    tmp2=reshape(x,h*w,z);
    for i=1:z
        tmp3(:,i)=tmp2(ind2,z);
    end
    clear tmp2;
    
    t1=reshape(tmp3,1,size(ind2,1)*z);
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
    ssize=5;  % next frame step size
    for i=1:z        
        imagescnan(x(:,:,fr), c);axis off;colorbar;title(['frame number: ' num2str(fr)]);
        pause(0.05);
        fr=fr+ssize;
        if fr > z
            break;
        end                   
    end
     
end
