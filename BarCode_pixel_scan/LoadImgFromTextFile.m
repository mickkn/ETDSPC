function [img] = LoadImgFromTextFile(im, name)
%% Load BW image from ascii text file

fid = fopen(name);
pixels = fscanf(fid, '%d\n');
img = im;
idx = 1;
for r=1:size(im, 1)
    for c=1:size(im, 2)
      if idx > size(pixels, 1) 
          img(r,c) = 0;
      else
          img(r,c) = uint8(pixels(idx));
      end;
      idx = idx + 1;
    end
end
fclose(fid);

end
