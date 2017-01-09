function [ PredShift ] = shrinkAlign( im,maxShift,scale )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
smallIm=imresize(im,scale);

smallShift=ceil(scale*maxShift);
[~,PredShift]=alignChannels(smallIm,smallShift);

end

