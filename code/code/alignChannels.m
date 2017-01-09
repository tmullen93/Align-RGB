function [imShift, predShift] = alignChannels(im, maxShift)
% ALIGNCHANNELS align channels in an image.
%   [IMSHIFT, PREDSHIFT] = ALIGNCHANNELS(IM, MAXSHIFT) aligns the channels in an
%   NxMx3 image IM. The first channel is fixed and the remaining channels
%   are aligned to it within the maximum displacement range of MAXSHIFT (in
%   both directions). The code returns the aligned image IMSHIFT after
%   performing this alignment. The optimal shifts are returned as in
%   PREDSHIFT a 2x2 array. PREDSHIFT(1,:) is the shifts  in I (the first) 
%   and J (the second) dimension of the second channel, and PREDSHIFT(2,:)
%   are the same for the third channel.
%
% This code is part of:
%
%   CMPSCI 670: Computer Vision, Fall 2016
%   University of Massachusetts, Amherst
%   Instructor: Subhransu Maji
%
%   Homework 1: Color images
%   Author: Subhransu Maji


% Sanity check
assert(size(im,3) == 3);
assert(all(maxShift > 0));


s=size(im);

%finding edges by subtracting each R,G,B plate from itself shifted over one
%pixels whose right neighbor is about the same value become grey, while the
%others become R,G, or B
diff=im(1:s(1)-1,:,:)-im(2:s(1),:,:);
%normalize so we can see the image
mn=min(min(min(diff)));
mx=max(max(max(diff)));
diff=(diff-mn)/(mx-mn);


%most pixels in the image have the same value in each RGB plate so find the
%mode of each plate
R=diff(:,:,1);
G=diff(:,:,2);
B=diff(:,:,3);
md_R=mode(mode(R));
md_G=mode(mode(G));
md_B=mode(mode(B));

%then if the pixel value is very close to the mode make it 0 while if it is
%far away make it 1
R=abs(R-md_R)>=10^-2;
G=abs(G-md_G)>=10^-2;
B=abs(B-md_B)>=10^-2;

%create a new image with the intense edges
imag_new(:,:,1)=R;
imag_new(:,:,2)=B;
imag_new(:,:,3)=G;



%Now begin exhaustive search over  30x30 window of shifts and test the L2
%norm
[min_im, shiftB]=moveBlueAround(imag_new,maxShift);
[~,shiftG]=moveGreenAround(min_im,maxShift);

predShift(1,:)=shiftG;
predShift(2,:)=shiftB;

final=im(:,:,1);
final(:,:,2)=circshift(im(:,:,2),predShift(1,:));
final(:,:,3)=circshift(im(:,:,3),predShift(2,:));

imShift=final;
end
%--------------------------------------------------------------------------
%                           moveBlueAround
%--------------------------------------------------------------------------


function [ min_im, shift ] = moveBlueAround( im, maxShift )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

min=sum(sum((im(:,:,1)-im(:,:,2)).^2));
min_im=im;
shift=[0,0];
for i=-maxShift(1):maxShift(1)
    for j=-maxShift(2):maxShift(2)
        imNew(:,:,2)=circshift(im(:,:,2),[i,j]);
        imNew(:,:,1)=im(:,:,1);
        imNew(:,:,3)=im(:,:,3);
        L2=sum(sum((imNew(:,:,1)-imNew(:,:,2)).^2));
        if L2<min
            min=L2;
            min_im=imNew;
            shift=[i,j];
        end
    end
end


end

%--------------------------------------------------------------------------
%                           moveGreenAround
%--------------------------------------------------------------------------

function [ min_im, shift ] = moveGreenAround( im,maxShift )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

min=sum(sum((im(:,:,1)-im(:,:,3)).^2));
min_im=im;
shift=[0,0];
for i=-maxShift(1):maxShift(1)
    for j=-maxShift(2):maxShift(2)
        imNew(:,:,3)=circshift(im(:,:,3),[i,j]);
        imNew(:,:,1)=im(:,:,1);
        imNew(:,:,2)=im(:,:,2);
        L2=sum(sum((imNew(:,:,1)-imNew(:,:,3)).^2));
        if L2<min
            min=L2;
            min_im=imNew;
            shift=[i,j];
        end
    end
end
end

