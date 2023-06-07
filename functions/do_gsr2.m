function [ scaff1,scaff2 ] = do_gsr2( dat, mask )
%Global signal regression with the Fox method.

%two output matrices, first one is the signal with GS regressed out.
%Second one is the global signal itself.

% updated to include masked values


mask=reshape(mask,size(mask,1)*size(mask, 2),1);
ind=find(mask==1);

s=size(dat);
% disp(s)
nFrame=s(3);
dat=reshape(dat,s(1)*s(2),s(3));

for i=1:size(dat,2)
    dat2(:,i)=dat(ind,i);
end
dat=dat2;
clear dat2;


dat=dat';
dat=double(dat);

avg_g=mean(dat,2);

g1 = pinv(avg_g);

Bg=g1*dat;

B1 = dat - avg_g * Bg;

B1 = B1';


% B1 = reshape(B1,128,128,nFrame);
scaff1=zeros(s(1)*s(2), s(3));
for i=1:nFrame
    scaff1(ind,i)=B1(:,i);
end
scaff1=reshape(scaff1, s(1), s(2), s(3));


% file_save = ['test_GSR.raw'];
% fid = fopen(file_save,'w', 'b');
% fwrite(fid, B1, 'float32');
% fclose(fid);

GS=avg_g*Bg;
GS=GS';

% GS=reshape(GS,128,128,nFrame);
scaff2=zeros(s(1)*s(2), s(3));
for i=1:nFrame
    scaff2(ind,i)=GS(:,i);
end
scaff2=reshape(scaff2, s(1), s(2), s(3));


% 
% file_save = ['test_GS.raw'];
% fid = fopen(file_save,'w', 'b');
% fwrite(fid,GS , 'float32');
% fclose(fid);

end

