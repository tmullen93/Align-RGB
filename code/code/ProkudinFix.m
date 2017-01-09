dataDir = fullfile('C:','Users','Terry','Documents','2016 School Year','Computer Vision',...
    'p1_code.tar','data','data','prokudin-gorskii');

% Path to your output directory (change this to your output directory)
outDir = fullfile('C:','Users','Terry','Documents','2016 School Year','Computer Vision',...
    'p1_code.tar','data','data', 'prokudin-gorskii');
if ~exist(outDir, 'file')
    mkdir(outDir);
end

imageNames='00153v.jpg';

im = imread(fullfile(dataDir, imageNames));
    
    % Convert to double
    im = im2double(im);
    
    % Images are stacked vertically
    % From top to bottom are B, G, R channels (and not RGB)
    imageHeight = floor(size(im,1)/3);
    imageWidth  = size(im,2);
    
    % Allocate memory for the image 
    channels = zeros(imageHeight, imageWidth, 3);
    
    % We are loading the color channels from top to bottom
    % Note the ordering of indices
    channels(:,:,3) = im(1:imageHeight,:);
    channels(:,:,2) = im(imageHeight+1:2*imageHeight,:);
    channels(:,:,1) = im(2*imageHeight+1:3*imageHeight,:);

    % Align the blue and red channels to the green channel
    [colorIm, predShift] = alignChannels(channels, maxShift);
    
    image(colorIm)