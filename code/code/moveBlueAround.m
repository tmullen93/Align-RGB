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

