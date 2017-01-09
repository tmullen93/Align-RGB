function output = demosaicImage(im, method)
% DEMOSAICIMAGE computes the color image from mosaiced input
%   OUTPUT = DEMOSAICIMAGE(IM, METHOD) computes a demosaiced OUTPUT from
%   the input IM. The choice of the interpolation METHOD can be 
%   'baseline', 'nn', 'linear', 'adagrad'. 
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images

switch lower(method)
    case 'baseline'
        output = demosaicBaseline(im);
    case 'nn'
        output = demosaicNN(im);         % Implement this
    case 'linear'
        output = demosaicLinear(im);     % Implement this
    case 'adagrad'
        output = demosaicAdagrad(im);    % Implement this

end


function mosim = demosaicBaseline(im)
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
[imageHeight, imageWidth] = size(im);

% Red channel (odd rows and columns);
redValues = im(1:2:imageHeight, 1:2:imageWidth);
meanValue = mean(mean(redValues));
mosim(:,:,1) = meanValue;
mosim(1:2:imageHeight, 1:2:imageWidth,1) = im(1:2:imageHeight, 1:2:imageWidth);

% Blue channel (even rows and colums);
blueValues = im(2:2:imageHeight, 2:2:imageWidth);
meanValue = mean(mean(blueValues));
mosim(:,:,3) = meanValue;
mosim(2:2:imageHeight, 2:2:imageWidth,3) = im(2:2:imageHeight, 2:2:imageWidth);

% Green channel (remaining places)
% We will first create a mask for the green pixels (+1 green, -1 not green)
mask = ones(imageHeight, imageWidth);
mask(1:2:imageHeight, 1:2:imageWidth) = -1;
mask(2:2:imageHeight, 2:2:imageWidth) = -1;
greenValues = mosim(mask > 0);
meanValue = mean(greenValues);
% For the green pixels we copy the value
greenChannel = im;
greenChannel(mask < 0) = meanValue;
mosim(:,:,2) = greenChannel;

%--------------------------------------------------------------------------
%                           Nearest neighbour algorithm
%--------------------------------------------------------------------------
function mosim = demosaicNN(im)
[imageHeight, imageWidth] = size(im);


mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
%red channel
if mod(imageHeight,2)==1
    %move red cells down
    mosim(2:2:imageHeight,1:2:imageWidth,1)=im(1:2:imageHeight-1, 1:2:imageWidth);
    %blue
    %move cells up
    mosim(1:2:imageHeight-1,2:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
    mosim(imageHeight,2:2:imageWidth,3)=im(imageHeight-1,2:2:imageWidth);
    if mod(imageWidth,2)==1
        %green
        mosim(3:2:imageHeight,1:2:imageWidth,2)=im(2:2:imageHeight,1:2:imageWidth);
        mosim(2:2:imageHeight,2:2:imageWidth,2)=im(1:2:imageHeight-1,2:2:imageWidth);
        mosim(1,1:2:imageWidth-1,2)=im(1,2:2:imageWidth);
        mosim(1,imageWidth,2)=im(1,imageWidth-1);
        %move cells over to right and down
        mosim(2:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight-1,1:2:imageWidth-1);
        %move cells over to right
        mosim(1:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth-1);
        %blue
        %move cells over left
        mosim(2:2:imageHeight,1:2:imageWidth-1,3)=im(2:2:imageHeight,2:2:imageWidth);
        mosim(2:2:imageHeight,imageWidth,3)=im(2:2:imageHeight,imageWidth-1);
        %move cells over left and up
        mosim(1:2:imageHeight-1,1:2:imageWidth-1,3)=im(2:2:imageHeight,2:2:imageWidth);
        mosim(imageHeight,1:2:imageWidth-1,3)=im(imageHeight-1,2:2:imageWidth);
        mosim(1:2:imageHeight-1,imageWidth,3)=im(2:2:imageHeight,imageWidth-1);
        mosim(imageHeight,imageWidth,3)=im(imageHeight-1,imageWidth-1);
    else
        %green
        mosim(3:2:imageHeight,1:2:imageWidth,2)=im(2:2:imageHeight,1:2:imageWidth);
        mosim(2:2:imageHeight,2:2:imageWidth,2)=im(1:2:imageHeight-1,2:2:imageWidth);
        mosim(1,1:2:imageWidth,2)=im(1,2:2:imageWidth);
        %red
        %move cells over to right and diown
        mosim(2:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight-1,1:2:imageWidth);
        %move cells over to right
        mosim(1:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth);
        %blue
        %move cells over left
        mosim(2:2:imageHeight,1:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
        %move cells over left and up
        mosim(1:2:imageHeight-1,1:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
        mosim(imageHeight,1:2:imageWidth,3)=im(imageHeight-1,2:2:imageWidth);
    end
else
    %move red cells down
    mosim(2:2:imageHeight,1:2:imageWidth,1)=im(1:2:imageHeight, 1:2:imageWidth);
    %blue
    %move cells up
     mosim(1:2:imageHeight,2:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
    if mod(imageWidth,2)==1
        %green
        mosim(3:2:imageHeight,1:2:imageWidth,2)=im(2:2:imageHeight-1,1:2:imageWidth);
        mosim(2:2:imageHeight,2:2:imageWidth,2)=im(1:2:imageHeight,2:2:imageWidth-1);
        mosim(1,1:2:imageWidth-1,2)=im(1,2:2:imageWidth);
        mosim(1,imageWidth,2)=im(1,imageWidth-1);
        %red
        %move cells over to right and diagonal
        mosim(2:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth-1);
        %move cells over to right
        mosim(1:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth-1);
        %blue
        %move cells over left
        mosim(2:2:imageHeight,1:2:imageWidth-1,3)=im(2:2:imageHeight,2:2:imageWidth);
        mosim(2:2:imageHeight,imageWidth,3)=im(2:2:imageHeight,imageWidth-1);
        %move cells up and over left
        mosim(1:2:imageHeight,1:2:imageWidth-1,3)=im(2:2:imageHeight,2:2:imageWidth);
        mosim(1:2:imageHeight,imageWidth,3)=im(2:2:imageHeight,imageWidth-1);
    else
        %green
        mosim(3:2:imageHeight,1:2:imageWidth,2)=im(2:2:imageHeight-1,1:2:imageWidth);
        mosim(2:2:imageHeight,2:2:imageWidth,2)=im(1:2:imageHeight,2:2:imageWidth);
        mosim(1,1:2:imageWidth,2)=im(1,2:2:imageWidth);
        %red
        %move cells over to right and diagonal
        mosim(2:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth);
        %move cells over to right
        mosim(1:2:imageHeight,2:2:imageWidth,1)=im(1:2:imageHeight,1:2:imageWidth);
        %blue
        %move cells over left
        mosim(2:2:imageHeight,1:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
        %move cells up and over left
        mosim(1:2:imageHeight,1:2:imageWidth,3)=im(2:2:imageHeight,2:2:imageWidth);
    end
end



%--------------------------------------------------------------------------
%                           Linear interpolation
%--------------------------------------------------------------------------
function mosim = demosaicLinear(im)
[imageHeight, imageWidth] = size(im);
mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
%green channel
%middle even rows even columns
mosim(2:2:imageHeight-1,2:2:imageWidth-1,2)=(im(1:2:imageHeight-2,2:2:imageWidth-1)...
    +im(2:2:imageHeight-1,1:2:imageWidth-2)+im(3:2:imageHeight,2:2:imageWidth-1)...
    +im(2:2:imageHeight-1,3:2:imageWidth))/4;
%middle odd rows odd columns
mosim(3:2:imageHeight-1,3:2:imageWidth-1,2)=(im(2:2:imageHeight-2,3:2:imageWidth-1)...
    +im(3:2:imageHeight-1,2:2:imageWidth-2)+im(4:2:imageHeight,3:2:imageWidth-1)...
    +im(3:2:imageHeight-1,4:2:imageWidth))/4;
%boundaries
%top boundary no corners
mosim(1,3:2:imageWidth-1,2)=(im(1, 2:2:imageWidth-2)+im(1,4:2:imageWidth)+im(2,3:2:imageWidth-1))/3;

if mod(imageHeight,2)==1
    %green
    %bottom boundary no corners
    mosim(imageHeight,3:2:imageWidth-1,2)=(im(imageHeight, 2:2:imageWidth-2)+im(imageHeight,4:2:imageWidth)+im(imageHeight-1,3:2:imageWidth-1))/3;
    %corner left side bottom
    mosim(imageHeight,1,2)=(im(imageHeight-1,1)+im(imageHeight,2))/2;
else
    %green
    %bottom boundary no corners
    mosim(imageHeight,2:2:imageWidth-1,2)=(im(imageHeight, 1:2:imageWidth-2)+im(imageHeight,3:2:imageWidth)+im(imageHeight-1,2:2:imageWidth-1))/3;
end

%left side no corners
mosim(3:2:imageHeight-1,1,2)=(im( 2:2:imageHeight-2,1)+im(4:2:imageHeight,1)+im(3:2:imageHeight-1,2))/3;
%corner left side top
mosim(1,1,2)=(im(1,2)+im(2,1))/2;


if mod(imageWidth,2)==1
    %red
    mosim(:,imageWidth,1)=mosim(:,imageWidth-1,1);
    %green
    %right side no corners
    mosim(3:2:imageHeight-1,imageWidth,2)=(im( 2:2:imageHeight-2,imageWidth)+im(4:2:imageHeight,imageWidth)+im(3:2:imageHeight-1,imageWidth-1))/3;
    %corner right side top
    mosim(1,imageWidth,2)=(im(1,imageWidth-1)+im(2,imageWidth))/2;
    %corner right side bottom
    mosim(imageHeight,imageWidth,2)=(im(imageHeight,imageWidth-1)+im(imageHeight-1,imageWidth))/2;
else
    %green
    mosim(2:2:imageHeight-1,imageWidth,2)=(im( 1:2:imageHeight-2,imageWidth)+im(3:2:imageHeight,imageWidth)+im(2:2:imageHeight-1,imageWidth-1))/3;
end

%red channel
%even columns in odd rows (exclude right side)
mosim(1:2:imageHeight,2:2:imageWidth-1,1)=(im(1:2:imageHeight,1:2:imageWidth-2)+im(1:2:imageHeight,3:2:imageWidth))/2;
%even rows in odd colums (exclude bottom)
mosim(2:2:imageHeight-1,1:2:imageWidth,1)=(im(1:2:imageHeight-2,1:2:imageWidth)+im(3:2:imageHeight,1:2:imageWidth))/2;
%even rows and even columns(middle only)
mosim(2:2:imageHeight-1,2:2:imageWidth-1,1)=(im(1:2:imageHeight-2,1:2:imageWidth-2)+im(1:2:imageHeight-2,3:2:imageWidth)...
    +im(3:2:imageHeight,1:2:imageWidth-2)+im(3:2:imageHeight,3:2:imageWidth))/4;


%odd columns even rows not the first or last
mosim(2:2:imageHeight,3:2:imageWidth-1,3)=(im(2:2:imageHeight,2:2:imageWidth-2)+im(2:2:imageHeight,4:2:imageWidth))/2;

%odd rows even columns not the first or last
mosim(3:2:imageHeight-1,2:2:imageWidth,3)=(im(2:2:imageHeight-2,2:2:imageWidth)+im(4:2:imageHeight,2:2:imageWidth))/2;

%odd columns odd rows not the first or last
mosim(3:2:imageHeight-1,3:2:imageWidth-1,3)=(im(2:2:imageHeight-2,2:2:imageWidth-2)+im(2:2:imageHeight-2,4:2:imageWidth)...
    +im(4:2:imageHeight,2:2:imageWidth-2)+im(4:2:imageHeight,4:2:imageWidth))/4;

if mod(imageHeight,2)==1
    %red bottom
    mosim(imageHeight,:,1)=mosim(imageHeight-1,:,1);
   %top
    mosim(1,:,3)=mosim(2,:,3);
    %bottom
    mosim(imageHeight,:,3)=mosim(imageHeight-1,:,3);
    %left
    mosim(:,1,3)=mosim(:,2,3);
    if mod(imageWidth,2)==1
        mosim(:,imageWidth,3)=mosim(:,imageWidth-1,3);
    end
end



%--------------------------------------------------------------------------
%                           Adaptive gradient
%--------------------------------------------------------------------------
function mosim = demosaicAdagrad(im)
[imageHeight, imageWidth] = size(im);
%mosim = repmat(im, [1 1 3]); % Create an image by stacking the input
%this way the borders are all linear interpolated first as well
mosim=demosaicLinear(im);
%green channel
%take difference between top and bottom and left and right for even columns
%and even rows
topMinusBot=abs(im(1:2:imageHeight-2,2:2:imageWidth-1)-im(3:2:imageHeight,2:2:imageWidth-1));
topBotAvg=(im(1:2:imageHeight-2,2:2:imageWidth-1)+im(3:2:imageHeight,2:2:imageWidth-1))/2;
leftMinusRight=abs(im(2:2:imageHeight-1,1:2:imageWidth-2)-im(2:2:imageHeight-1,3:2:imageWidth));
leftRightAvg=(im(2:2:imageHeight-1,1:2:imageWidth-2)+im(2:2:imageHeight-1,3:2:imageWidth))/2;

%boolean matrix if 1 then top is less than left
topLessLeft=topMinusBot<leftMinusRight;
%boolean matrix if 1 then left is less than top
leftLessTop=leftMinusRight<topMinusBot;
topEqualLeft=leftMinusRight==topMinusBot;
%any cells where top minus bottom is equal to left minus right choose top
%minus bottom
topEqualLeft=leftRightAvg.*topEqualLeft;
%any cells where left minus right is greater than top minus bottom set to
%zero
topBotAvg=topBotAvg.*topLessLeft;
%any cells where top minus bottom is greater than left minus right set to
%zero
leftRightAvg=leftRightAvg.*leftLessTop;

mosim(2:2:imageHeight-1,2:2:imageWidth-1,2)=topBotAvg+leftRightAvg+topEqualLeft;

%take difference between top and bottom and left and right for odd rows odd
%columns
topMinusBot=abs(im(2:2:imageHeight-2,3:2:imageWidth-1)-im(4:2:imageHeight,3:2:imageWidth-1));
topBotAvg=(im(2:2:imageHeight-2,3:2:imageWidth-1)+im(4:2:imageHeight,3:2:imageWidth-1))/2;
leftMinusRight=abs(im(3:2:imageHeight-1,2:2:imageWidth-2)-im(3:2:imageHeight-1,4:2:imageWidth));
leftRightAvg=(im(3:2:imageHeight-1,2:2:imageWidth-2)+im(3:2:imageHeight-1,4:2:imageWidth))/2;

%boolean matrix if 1 then top is less than left
topLessLeft=topMinusBot<leftMinusRight;
%boolean matrix if 1 then left is less than top
leftLessTop=leftMinusRight<topMinusBot;
topEqualLeft=leftMinusRight==topMinusBot;

%any cells where top minus bottom is equal to left minus right choose top
%minus bottom
topEqualLeft=leftRightAvg.*topEqualLeft;
%any cells where left minus right is greater than top minus bottom set to
%zero
topBotAvg=topBotAvg.*topLessLeft;
%any cells where top minus bottom is greater than left minus right set to
%zero
leftRightAvg=leftRightAvg.*leftLessTop;

mosim(3:2:imageHeight-1,3:2:imageWidth-1,2)=topBotAvg+leftRightAvg+topEqualLeft;
