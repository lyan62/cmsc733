An end-to-end pipeline for image panorama stitching is implemented in this project.

1.To run the wrapper function in matlab, your current directory should be '/Code/'.
The wrapper function warpper(Imfolder,Imfiles) takes two inputs: Imfolder and Imfiles

Before call the function, the input parameters should be set in a same way as
Imfolder = 'CustomSet1';
Imfiles = {'1.jpg','2.jpg','3.jpg','4.jpg'} ;
and the folder of the image files should be in the Images folder
then the function can be called.

2. If you want to use images in a folder directly, run ex_imwarp.m
with folder defined in testdir = './Images/TestSet2/'


3. Experimental mosaic method using interpolation is in ex_interp.m(with reference to http://www.oocities.org/sd2002leap/), can be run in a same way as ex_imwap.m
