Test bench for edge detection filter:

edge_detect_file_tb.vhd:

- This test bench reads an image from the file ImageIn.txt where all BW 
pixels are stored as ascii decimal values
- The result are stored in the ImageOut.txt file

imageConvert.m:

- Matlab program that reads image and generates ImageIn.txt reads ImageOut.txt and displays 
BW image
 