function [] = SaveImgInTextFile(h, name, format)
%% Save BW image as ascii text file
% Format : '%d' decimal or '%x' hexidecimal

fid = fopen(name, 'w');
for r=1:size(h, 1)
    for c=1:size(h, 2)
      xtext = num2str(h(r,c), format);
      fprintf(fid, '%s\n', xtext); 
    end
end
fclose(fid);

end
