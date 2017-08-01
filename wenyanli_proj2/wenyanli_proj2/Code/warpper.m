clc;
close all;
clear all;

% assigning the name of sample avi file to a variable
filename = 'Video1.avi';

%reading a video file
mov = VideoReader(filename);

% Defining Output folder as 'snaps'
opFolder = fullfile(cd, 'snaps');
%if  not existing 
if ~exist(opFolder, 'dir')
%make directory & execute as indicated in opfolder variable
mkdir(opFolder);
end

%getting no of frames
numFrames = mov.NumberOfFrames;

%setting current status of number of frames written to zero
numFramesWritten = 0;

%for loop to traverse & process from frame '1' to 'last' frames 
for t = 1 : numFrames
currFrame = read(mov, t);    %reading individual frames
%opBaseFileName = sprintf('%3.3d.png', t);
resized = imresize(currFrame,[460 NaN]);
opBaseFileName = sprintf('%d.png', t);
opFullFileName = fullfile(opFolder, opBaseFileName);
imwrite(resized, opFullFileName, 'png');   %saving as 'png' file
%indicating the current progress of the file/frame written
progIndication = sprintf('Wrote frame %4d of %d.', t, numFrames);
disp(progIndication);
numFramesWritten = numFramesWritten + 1;
end      %end of 'for' loop
progIndication = sprintf('Wrote %d frames to folder "%s"',numFramesWritten, opFolder);
disp(progIndication);
%End of the code

%%
%% Wrapper to run dlib's face landmark detector
CodePath = './FaceLandmarksNitin.py';
PredictorPath = 'shape_predictor_68_face_landmarks.dat';
%FacesPath = '../examples/faces2/Nitin.jpg';
for i  = 1:numFrames
    FacesPath{i} = ['./snaps/' num2str(i) '.png']
    Command = ['python ', CodePath, ' ', PredictorPath, ' ', FacesPath{i}];
   [status, cmdout] = system(Command);
   I{i} = imread(FacesPath{i});
   %I{i} = imresize(I{i},[460 NaN]);
   %imshow(I);
   % Parse the console output and prettify it - please do not modify this code
   FaceData{i} = ParseInputs(cmdout);
% Plot Bounding Boxes - feel free to look into the code and extract them
   %PlotBB(FaceData);
% Plot LandMarks - feel free to look into the code and extract them
   %PlotLandMarks(FaceData);

end
%%
FacesPath_source= '../sample/emma.jpg';
Command_source = ['python ', CodePath, ' ', PredictorPath, ' ', FacesPath_source];
[status, cmdout_source] = system(Command_source);
I_source = imread(FacesPath_source);
FaceData_source = ParseInputs(cmdout_source);

% Defining Output folder as 'snaps'
faceFolder = '../results/';
%if  not existing 
if ~exist(faceFolder, 'dir')
%make directory & execute as indicated in opfolder variable
mkdir(faceFolder);
end
%%
for i  = 1:3:numFrames
    disp(['Iteration : ' , num2str(i) ,'th frame']);
    im_morphed{i} = triangulation_method(FaceData{i},FaceData_source,I{i},I_source);
    %im_morphed{i} = tps_method(FaceData{i},FaceData_source,I{i},I_source);
    %imwrite(output{i}, ['swaped' i], 'png');
    [img_proc,mask] = defineRegion(I{i},FaceData{i}.LandMarks);%,facerec_dest);
    img_morphed_proc = histeq_rgb(im_morphed{i},I{i}, mask, mask);
    sigma = 5;
    se = strel('square',sigma);
    mask = imerode(mask,se);
    w = fspecial('gaussian',[50 50],sigma);
    mask = imfilter(double(mask),w);
    im_result{i} = bsxfun(@times,im2double(img_morphed_proc),double(mask)) + bsxfun(@times,im2double(I{i}),double(1-mask));
    %imwrite(im_result{i},[faceFolder,[num2str(i),'.png']]);
end
   
%%

im_result = im_result(~cellfun('isempty',im_result)) ;
outputVideo = VideoWriter(fullfile(faceFolder,'Video1Out.avi'));
outputVideo.FrameRate = 20;
open(outputVideo)

%for ii = length(output)
for ii = 1: length(im_result)
    %img = imread(fullfile(faceFolder,'images',output{ii}));
    writeVideo(outputVideo,im2uint8(im_result{ii}))
end
close(outputVideo)

%%
out_wenyanliAvi = VideoReader(outputVideo);
ii = 1;
while hasFrame(out_wenyanliAvi)
    outmov(ii) = im2frame(readFrame(out_wenyanliAvi));
    ii = i+1;
end


