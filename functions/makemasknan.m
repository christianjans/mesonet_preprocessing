function masknan=makemasknan(mask)
% edited 2020-02-18 by BHope to remove redundant line of code
% change 0 values in mask to NaNs
% 1 values within mask remain 1
	mask=double(mask);
	masknan(mask==0)=NaN;
    masknan=reshape(masknan,size(mask,1),size(mask,2));
	masknan=masknan+mask;
end

