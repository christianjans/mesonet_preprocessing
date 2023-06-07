%% ///// Noisy frame removal \\\\\
% determine threshold mean and standard deviation (based on all pixels within mask)
% remove frames that deviate outside within mask global average +/-
% threshold
mask=reshape(mask,256*256,1);
maskind=find(mask==1);
mask=reshape(mask,256,256);
im2=reshape(im1,256*256,size(im1,3));
im2=im2(maskind,:);
im2=mean(im2,1);
thrmean=mean(im2);
thrsd=std(im2);
multiple=1; % multiple of SD to use for excluding frames
clear frgood;
clear frbad;
ind1=1; % good frame index
ind2=1; % bad frame index
for i=1:size(im2,2)
    disp(num2str(i));
    if (im2(:,i) >= (thrmean - thrsd*multiple)) & (im2(:,i) <= (thrmean + thrsd*multiple))
%         disp('good');
%         im2(:,ind1)=im1(:,i);
        frgood(ind1)=i;  % index of good frames
        ind1=ind1+1;
    else
%         disp('noisy');
        frbad(ind2)=i;  % index of bad frames
        ind2=ind2+1;
    end
end
% isolate "good" frames from initial matrix
imfixed=im1(:,:,frgood); % work from this matrix

