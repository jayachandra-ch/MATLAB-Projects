function [ score ] = calcAUCscore( salMap, eyeMap, shufMap, numRandom )
%CALCAUCSCORE Calculate AUC score of a salmap
%   Usage: [score] = calcAUCscore ( salmap, eyemap, shufflemap, numrandom )
%
%   score     : an array of score of each eye fixation
%   salmap    : saliency map. will be resized nearest neighbour to eyemap
%   eyemap    : should be a binary map of eye fixation
%   shufflemap: other image's eye fixation, if undefined will give all
%               white (all white/ones will be random auc instead)
%   numrandom : number of random points sampled from shufflemap
%               default: 100
% nargin returns the number of input arguments passed in the call % to the currently executing function. .
if nargin < 3
    shufMap = true(size(eyeMap));
end
% shufmap array is of eye map size with all ones.
if nargin < 4
    numRandom = 100;
end
% An empty array has atleast one dimension of size zero for            % example o-by-0 or 0-by-5
if isempty(shufMap) || max(max(shufMap)) == 0 % its empty or no fixation at all
    shufMap = true(size(eyeMap));
end

%%% Resize and normalize saliency map
%usually the saliency map is of lower resolution so you make it %%nearest to the size of eye fixation map
salMap = double(imresize(salMap,size(eyeMap),'nearest'));
salMap = salMap - min(min(salMap));
salMap = salMap / max(max(salMap));

%%% Pick saliency value at each eye fixation along with [numrandom] random points
[X Y] = find(eyeMap > 0);
% x,y are the positions at which eye map is greater than zero.
[XRest YRest] = find(shufMap > 0);

% numberOfElements = length(array) finds the number of elements  %along the largest dimension of an array
%NaN returns the IEEE® arithmetic representation for Not-a-Number %(NaN). These result from operations which have undefined        %numerical results. NaN(m,n) or NaN([m,n]) is an m-by-n matrix   % of NaNs.
localHum = nan(length(X),1);
localRan = nan(length(X),numRandom);

for k=1:length(X)


% copy values of saliency maps positions that correspond to eye- % tracker map white values

    localHum(k,1) = salMap(X(k),Y(k));

    for kk=1:numRandom

% xRest is shuffmap x co-ordinate positions whose value is >0
% randi-uniformly distribute psuedorandom integers.               % A=randi([2,5],2); generates a two-by-two array of number b/w 2 % and 5


        r = randi([1 length(XRest)],1);

% copy values of saliency maps positions that correspond to shuffle map's random X position whose value is greater than 0

        localRan(k,kk) = salMap(XRest(r),YRest(r));
    end
end

%%% Calculate AUC score for each eyefix and randpoints
ac = nan(1,size(localRan,2));
% cell function creates a cell array that contains 4 pointers,   %each of which can point to an arbitrary type. for example
%B = cell(1, 4);
%B{1,1} = 10;
%B{1,2} = 20;
%B{1,3} = 30;
%B{1,4} = 40;


R  = cell(1,size(localRan,2));

% M = SIZE(X,DIM) returns the length of the dimension specified
 %   by the scalar DIM.

for ii = 1:size(localRan,2)
    [ac(ii), R{ii}] = auc(localHum, localRan(:, ii));
end
score = ac;

end

