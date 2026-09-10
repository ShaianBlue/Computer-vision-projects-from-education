%% Preperations
% Clearing all the variables
clear
% Closing all the windows
close all
% Clearing the Command Window
clc
% Get the images from the files
addpath([pwd, '/Videos'])
% The text and line is costumized to look more 'clean'
set(0, 'DefaultTextInterpreter', 'latex');
FNT_SZ = 16;
set(0, 'DefaultAxesFontSize', FNT_SZ);
set(0, 'DefaultLineLineWidth', 2);
% The chosen video to be analysed from 1 to 5
chosen_video = 1;
if chosen_video == 1
    % The video has been read
    video = VideoReader('Test 1.mp4');
elseif chosen_video == 2
    % The video has been read
    video = VideoReader('Test 2.mp4');
elseif chosen_video == 3
    % The video has been read
    video = VideoReader('Test 3.mp4');
elseif chosen_video == 4
    % The video has been read
    video = VideoReader('Test 4.mp4');
elseif chosen_video == 5
    % The video has been read
    video = VideoReader('Test 5.mp4');
else
    % The video has been read
    video = VideoReader('Test 1.mp4');
end
% Variable for live analysis, 1 for live analysis and 0 for conversion to
% video
live = 1;
% Make a video and start from here
if live == 0
    if chosen_video == 1
        % The video has been opened
        new_video = VideoWriter('Result 1.avi');
        open(new_video);
    elseif chosen_video == 2
        % The video has been opened
        new_video = VideoWriter('Result 2.avi');
        open(new_video);
    elseif chosen_video == 3
        % The video has been opened
        new_video = VideoWriter('Result 3.avi');
        open(new_video);
    elseif chosen_video == 4
        % The video has been opened
        new_video = VideoWriter('Result 4.avi');
        open(new_video);
    elseif chosen_video == 5
        % The video has been opened
        new_video = VideoWriter('Result 5.avi');
        open(new_video);
    else
        % The video has been opened
        new_video = VideoWriter('Result 1.avi');
        open(new_video);
    end
end

%% Play video
% The first frame is brought back
read(video, 1);
% Converting every frame to an image and displaying the frames
figure(1);
while hasFrame(video)
    % Getting all the frames
    frame = readFrame(video);
    % Detect racket
    Mask = RacketDet(frame);
    % Find the position and orientation of the image
    image = PosAndOrient(Mask, frame);
    % If rackets have been detected, then show the detected racket
    if live == 0
        % Append the original image to the video
        writeVideo(new_video, image);
    else
        % Show the original image
        imshow(image);
        % Title for the time
        title(sprintf('Current Time: %.3f s', video.CurrentTime));
    end
end
% Close the video
if live == 0
    close(new_video);
end
