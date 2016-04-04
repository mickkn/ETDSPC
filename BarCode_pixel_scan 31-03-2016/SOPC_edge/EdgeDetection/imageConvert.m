%% KBE, 26/2-2013
clear, close all;

%% Read image and save as ascii hex file

%img = imread('rice.tif');
img = imread('blood1.tif');
imshow(img);
SaveImgInTextFile(img, 'ImageIn12.txt', '%d'); % Format %d or %x

imgEdge = LoadImgFromTextFile(img, 'ImageOut.txt');
figure;
imshow(imgEdge);