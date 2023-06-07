function [h] = imagescnan(a,crange,nanclr,cm)
% IMAGESC with NaNs assigning a specific color to NaNs
% http://stackoverflow.com/questions/8481324/contrasting-color-for-nans-in-imagesc
%
% I had to modify this as I often want to show a colorange that thresholds values below a certain cutoff but do not wish
% to have these values assigned the same colour as the NaNs. Therefore, this function is modified to search for the 
% lowest step in the colourscale and assign all values below that to the lowest displayed value still within the colour
% nanclear is the 3-value RGB triplet defining color
% crange is a vector specifying low and high end (as in imagesc): eg. [0 1];
%
% modified July 5, 2017 (low end-values were not scaled correctly)
% modified June 2, 2020 (adding input arguments for NaN colour and for colour map, removed hcb output)

if nargin<3
	nanclr=[0 0 0];
	cm=viridis;
end

if nargin == 1
    %# find minimum and maximum
	amin=min(a(:));
	amax=max(a(:));
	% size of colourmap
	n = size(cm,1);	
	% colour step
	dmap=(amax-amin)/n; 
    a(a<=amin)=amin+dmap; % change all values below low end of cutoff to low end + smallest step
else
	amin=crange(1,1);
	amax=crange(1,2);
	n = size(cm,1);	% size of colourmap
	dmap=(amax-amin)/n; % colour step
    a(a<=amin)=amin+dmap; % change all values below low end of cutoff to low end + smallest step
end

%# standard imagesc
him = imagesc(a);
%# add nan colour to colourmap
colormap([nanclr; cm]); % concatonate nanclr to the top of the colormap matrix
%# changing colour limits
caxis([amin amax]);
%# place a colourbar
% hcb = colorbar;
%# change Y limit for colorbar to avoid showing NaN color
% ylim(hcb,[amin amax])

if nargout > 0
    h = him;
end