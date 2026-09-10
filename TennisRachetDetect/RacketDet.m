function [M] = RacketDet(im)
%RacketDet: Find the detection of the racket.
%   We are given an image as an input, and we output a logical matrix, with
%   the relevant values for the detection.
%   M = RacketDet(im)

    % Mask all the black colored region
    mask1 = BlackMask(im);
    % Mask all the red colored region
    mask2 = RedMask(im);
    % Mask all the elements we want
    mask3 = BackgroundMask(im);
    % Both mask will be used
    mask = and(or(mask1, mask2), not(mask3));
    % Grayscaled version of the input image
    frameGray = rgb2gray(im);
    % Edges is found using the Canny detection
    Edge_Canny = edge(frameGray, 'Canny');
    % To make sure that we can separate the logical objects, we subtract
    % the preferred colored object with the edges
    M_edge = and(mask, not(Edge_Canny));
    % Filling the holes
    M = imfill(M_edge, 8, 'holes');
end

