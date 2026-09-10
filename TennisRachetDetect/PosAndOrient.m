function [show] = PosAndOrient(bitmask, orig_image)
%PosAndOrient: Find the detection of the racket.
%   We are given the bitmask and its corresponding image as an input, and 
%   we output an image with either shapes inserted or the original image.
%   show = PosAndOrient(bitmask, orig_image)
    
    % Making a table, with information of the centroid, major axis, minor
    % axis, eccentricity and orientation for eevery ellipsoid detected in
    % the mask
    stats = regionprops('table', bitmask, 'Centroid', 'MajorAxisLength', 'MinorAxisLength', 'Eccentricity', 'Orientation');
    % Finding all the centers
    center = stats.Centroid;
    % Finding all the major and minor axis
    major_axis = stats.MajorAxisLength;
    minor_axis = stats.MinorAxisLength;
    % Finding the eccentricity
    eccen = stats.Eccentricity;
    % Finding the polar angle (from x-axis to y-axis)
    theta = stats.Orientation;
    % Finding the index, with a major axis betwenn 35 and 55 pixel and
    % making sure that those aren't a line
    index = find(and(and(major_axis >= 35, major_axis <= 55), eccen < 0.9));
    % Rewritening the elements, so the have the rigth index
    center = center(index, :);
    major_axis = major_axis(index);
    minor_axis = minor_axis(index);
    eccen = eccen(index);
    theta = theta(index);
    % Ratio between the heigth and width of the blade
    blade_ratio = 15.5 / 15;
    % Using the ratio to find out what the real minor axis should look
    % like, if it was placed flat at the xy-plane
    real_minor = major_axis / blade_ratio;
    if real_minor < minor_axis
        % Finding the azimuthal angle (from z-axis to the point determined
        % by theta)
        phi = asin(minor_axis ./ real_minor) * 180 / pi;
    else
        % The real minor axis cannot be over the projected minor axis
        phi = 90;
    end
    % Displaying the circles and their center
    if isempty(center) == 0
        % Makes an area for the detected ellipses, indicating their
        % position
        detect = insertShape(orig_image, "FilledCircle", [center(:, 1), center(:, 2), major_axis / 2], 'Color', 'g');
        % Finding the direction of the spherical coordinate onto the
        % euclidean coordinate
        dir1 = center(:, 1) + (major_axis / 2 .* sin(phi * pi / 180) .* cos(theta * pi / 180));
        dir2 = center(:, 2) + (major_axis / 2 .* sin(phi * pi / 180) .* sin(theta * pi / 180));
        % Makes an "arrow" for the detected ellipses, indicating their
        % direction
        direct = insertShape(detect, "Line", [center(:, 1), center(:, 2), dir1, dir2], 'Color', 'm', 'LineWidth', 5);
        % Displaying the detected frame
        show = direct;
    else
        % Displaying the frames
        show = orig_image;
    end
end

