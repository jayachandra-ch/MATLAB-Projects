function [ score ] = calcCCscore( salMap, eyeMap )
%calcCCscore Calculate CC score of a salmap
%   Usage: [score] = calcCCscore ( salmap, eyemap, gaussSize )
%
%   score     : an array of score of each eye fixation
%   salmap    : saliency map. will be resized nearest neighbour to eyemap
%   eyemap    : should be a binary map of eye fixation
%   gaussSize : size of the gaussian blob for eye fixation. default: 10

 if nargin < 3
    gaussSize = 10;
 end

%%% Gaussian blob
dims = [50 50]; sigma = gaussSize; % gaussian standard deviation in pixels <<<<<<<<<<<<<
P = [round(dims(1)/2) round(dims(2)/2)];
[Xm Ym] = meshgrid(-P(2):P(2), -P(1):P(1)); s = sigma ;
gauss = exp(-((( Xm.^2)+( Ym.^2)) ./ (2* s.^2)));

%%% Resize and normalize saliency map
salMap = double(imresize(salMap,size(eyeMap),'nearest'));
mapMean = mean2(salMap); mapStd = std2(salMap);
salMap = (salMap - mapMean) / mapStd; % Normalized map

%%% Put gaussian to eye position
himg=double(eyeMap);
humanMap = conv2(himg,gauss,'same');
humanMap = humanMap  - min(min(humanMap));
humanMap = humanMap  / max(max(humanMap));
% binarymap=humanMap;
% [m n]=size(humanMap);
% for i=1:1:m
%     for j=1:1:n
%         if binarymap(i,j)>0
%             binarymap(i,j)=1;
%         end;
%     end;
% end;
% binarymap=conv2(binarymap,gauss,'same');
% figure(1);
% imshow(humanMap);
%  figure(2);
%  imshow(binarymap);
% h=fspecial('gaussian',[150 150],150);
% blurredimage=imfilter(humanMap,h,'same','conv');
% I=mat2gray(blurredimage);
% oldfolder=pwd;
% cd('C:\focusdetection algorithm\exp1\Judd\ALLSTIMULI\saliencymapsat0.7');
% filename=char(strcat(filename,'.bmp'));
% 
%  imwrite(I, filename,'bmp');
%  cd(oldfolder);
%%% Correlation map
score = corr2(salMap, humanMap);

end

