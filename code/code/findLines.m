
clear all
dataDir = fullfile('C:','Users','Terry','Documents','2016 School Year','Computer Vision',...
    'p1_code.tar','data','data','demosaic');



thisImage = fullfile(dataDir,'cat.jpg');
im = imread(thisImage);
im = im2double(im);
figure
image(im)
maxShift = [15 15];

% Randomly shift channels
[channels, gtShift]  = randomlyShiftChannels(im, maxShift);
figure
image(channels)

s=size(channels);

%finding edges by subtracting each R,G,B plate from itself shifted over one
%pixels whose right neighbor is about the same value become grey, while the
%others become R,G, or B
diff=channels(1:s(1)-1,:,:)-channels(2:s(1),:,:);
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
R=abs(R-md_R)>=10^-1;
G=abs(G-md_G)>=10^-1;
B=abs(B-md_B)>=10^-1;

%create a new image with the intense edges
imag_new(:,:,1)=R;
imag_new(:,:,2)=B;
imag_new(:,:,3)=G;


% imag_new1(:,:,1)=circshift(imag_new(:,:,1),[15,15]);
% imag_new1(:,:,2:3)=imag_new(:,:,2:3);
% figure
% image(imag_new1)
%Now begin exhaustive search over  30x30 window of shifts and test the L2
%norm
[min_im, shiftB]=moveBlueAround(imag_new);
[min_im,shiftG]=moveGreenAround(min_im);

figure
image(min_im)

final=channels(:,:,1);
final(:,:,2)=circshift(channels(:,:,2),shiftG);
final(:,:,3)=circshift(channels(:,:,3),shiftB);
figure 
image(final)
% Rstart=find(abs(R-md_R)>10^-10,1)
% Gstart=find(abs(G-md_G)>10^-10,1)
% Bstart=find(abs(B-md_B)>10^-10,1)
% 
% 
% 
% 
% gtShift

