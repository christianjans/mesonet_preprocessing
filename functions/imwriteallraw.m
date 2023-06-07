% Modified to removed for-loop for image rotation
% Modified 2016-09-02

function imwriteallraw(filename,img,precision)

    % '*uint8' 8 bit imaging, raw data, behavioral camera
    % '*uint16' 16 bit imaging, raw data, VSD camera
    % '*float32' 32 bit, filtered data, VSD camera
      
   disp(' ');
   disp('Saving...');
   
   img=flipud(rot90(img));
 
   fid = fopen(filename,'w', 'b');
   fwrite(fid, img, precision);
   fclose(fid);
   fprintf(1,'%s\n',filename);

   disp('Saving... completed.');
end