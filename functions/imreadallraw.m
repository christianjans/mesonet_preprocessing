%% MATLAB binary image file reader (*.bin/*.raw) 
%
% Note: image rotation on line 26.
%
% Last modified: January 31, 2020 (AWC)


function img = imreadallraw(filename,x,y,nFrame,precision)
	%
	% filename: MATLAB binary image
	% x: row dimension
	% y: column dimension
	% nFrame: number of frames
	% precision:  
		% 'uint8' 8 bit imaging
		% 'uint16' 16 bit imaging
		% 'float32' 32 bit imaging
    
    disp(' ');
    disp('Loading...');
    fid0 = fopen(filename, 'r', 'b');
    img = fread(fid0,[x*y nFrame],precision);
    fclose(fid0);
    
    img = reshape(img,x,y,nFrame);
    img = flipud(rot90(img));

    disp('Loading... completed.');
end
