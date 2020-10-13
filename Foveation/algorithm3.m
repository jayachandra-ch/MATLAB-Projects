clc;
clear all;
outputvideo = 'foveatedtractor.avi';
inputvideo = 'tractorinput.avi';
readerobj = VideoReader(inputvideo);
writerObj = VideoWriter(outputvideo,'Uncompressed AVI');
writerObj.FrameRate=readerobj.FrameRate;
numFrames = readerobj.NumberOfFrames;

vidHeight = readerobj.Height;
vidWidth = readerobj.Width;
open(writerObj);
for frames = 1 : numFrames
    
       if (frames-1)==0
           j=1;
       else
           j=(frames-1);
       end;
       
%     mov(j:frames) = ...
mov(1:2) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);

    
    vidFrames = read(readerobj,[j frames]); 
% for i=j:frames
    mov(1).cdata = vidFrames(:,:,:,1);   
    if j==1
    mov(2).cdata=vidFrames(:,:,:,1); 
    else
    mov(2).cdata=vidFrames(:,:,:,2); 
    end;
    
% end;

 clear  vidFrames;

    currentimage= frame2im(mov(2));
%     if (frames==1)
    previousimage=frame2im(mov(1));
%     else
%         previousimage=frame2im(mov(frames-1));
%     end;    
    clear mov;
%     imshow(previousimage);
out=phaseQFT(currentimage,previousimage,1.0);
% figure(1000);
% imshow('hd.bmp');
% title('original image');
salmap=out;
% figure(2);
% imshow(salmap);
% title('saliency Map');
[r c]= size(out);
avg=mean2(out);
 for i=1:1:r
        for j=1:1:c
            if (out(i,j)>(3*avg))
                out(i,j)=1;
            else
                out(i,j)=0;               
            end
        end 
 end

[labelledbinaryimage,total] = bwlabel(out); 
save=zeros([total,1]);
  for i=1:1:total  
    s = regionprops(labelledbinaryimage,'PixelIdxList','Area','PixelList');
    idx = s(i).PixelIdxList;
    smapregionavg=mean(salmap(idx));
    objectarea=s(i).Area;
    product=smapregionavg*objectarea;
    save(i,1)=product;
  end
 sortedarray=sort(save,'descend');
 rankarray= zeros([total,2]);
 for i=1:total
    [r c]=find(sortedarray(i)==save);
        rankarray(i,1)=r;
        rankarray(i,2)=c;
 end

% figure(21);
% imshow(ImL);
% title('FOCAL POINTS MAP');
if total>8
    fovcount=8;
else
    fovcount=total;
end
 
xbars= zeros(fovcount,1);
ybars=zeros([fovcount,1]);
% hold on;

for k = 1:1:fovcount
   labelnumber= rankarray(k,1);
    idxs = s(labelnumber).PixelIdxList;
    pixel_values = double(salmap(idxs));
    sum_pixel_values = sum(pixel_values);
    x = s(labelnumber).PixelList(:, 1);
    y = s(labelnumber).PixelList(:, 2);
    xbars(k,1) = sum(x .* pixel_values) / sum_pixel_values;
    ybars(k,1) = sum(y .* pixel_values) / sum_pixel_values;
%      disp(xbars(k,1));disp(ybars(k,1));
%     plot(xbars(k,1), ybars(k,1), '*')
end
% hold off;


file = currentimage; 			% file to foveate
outfile = 0; 				% generate output files from movie?
use_ycbcr = 0; 				% use rgb or ycbcr for foveation?
levels = 7; 				% number of pyramid levels

focalpoints=zeros([fovcount,2]);
for t=1:1:fovcount
    focalpoints(t,1)=xbars(t,1);
    focalpoints(t,2)=ybars(t,1);
end

CT0 = 1/75; 				% constant from Geisler&Perry
alpha = (0.106)*1; 			% constant from Geisler&Perry
epsilon2 = 2.3; 			% constant from Geisler&Perry
dotpitch = .462*(10^-3); 		% monitor dot pitch in meters
viewingdist = 1.67; 			% viewing distance in mete

color_img = double(file);

% normalize the values to some maximum value; for most MATLAB
% functions, this value must be one.
max_cval = 1.0;
range = [min(color_img(:)) max(color_img(:))];
img_size = size(color_img(:,:,1));
% disp(size(color_img(:,:,1)));
color_img = max_cval.*(color_img-range(1)) ./ (range(2)-range(1));

% if we're using YCbCr values for foveation, then convert over to them now.
if use_ycbcr == 1
  color_img = rgb2ycbcr(color_img);
end


exy = struct('x',{},'y',{});  
 exy(8).x=zeros(1920, 1080,'uint8');
 exy(8).y=zeros(1920, 1080,'uint8');
eradius = struct('radius',{}); 
 eradius(8).radius=zeros(1920, 1080,'uint8');
ec = struct('ec',{});
ec(8).ec=zeros(1920, 1080,'uint8');
maxfreq = struct('maxfreq',{});
maxfreq(8).maxfreq=zeros(1920, 1080,'uint8');
eyefreq = struct('eyefreq',{});
eyefreq(8).eyefreq=zeros(1920, 1080,'uint8');
pyrlevel = struct('pyrlevel',{});
pyrlevel(8).pyrlevel=zeros(1920, 1080,'uint8');

for i=1:1:fovcount
     [exy(i).x,exy(i).y]= meshgrid(-focalpoints(i,1)+1:img_size(2)-focalpoints(i,1),-focalpoints(i,2)+1:img_size(1)-focalpoints(i,2));
     eradius(i).radius=dotpitch .* sqrt((exy(i).x).^2+ (exy(i).y).^2);
    ec(i).ec=180*atan((eradius(i).radius) ./ viewingdist)/pi;
    maxfreq(i).maxfreq = pi ./ ((atan((eradius(i).radius+dotpitch)./viewingdist) - ...
                  atan((eradius(i).radius-dotpitch)./viewingdist)).*180);
eyefreq(i).eyefreq = ((epsilon2 ./(alpha*(ec(i).ec+epsilon2))).*log(1/CT0));   
pyrlevel(i).pyrlevel=(maxfreq(i).maxfreq)./ (eyefreq(i).eyefreq);
pyrlevel(i).pyrlevel=max(1,min(levels,(pyrlevel(i).pyrlevel)));
if i==1
    minpyrlevel= pyrlevel(1).pyrlevel;
end
if (i>1)
minpyrlevel= bsxfun(@min,minpyrlevel,(pyrlevel(i).pyrlevel));
end
% clear ec(i).ec pyrlevel(i).pyrlevel maxfreq(i).maxfreq  eyefreq(i).eyefreq eradius(i).radius   exy(i).x exy(i).y;
clear ec pyrlevel maxfreq eyefreq eradius exy;
end
clear ec pyrlevel maxfreq eyefreq eradius exy;
% show the foveation region matrix: 
% figure(200);
% showIm(levels - minpyrlevel);
% title('Foveation Region: white means higher resolution');
%  
% create storage for our final foveated image
foveated = zeros(img_size(1),img_size(2),3);

% create matrices of x&y pixel values for use with interp3
[xi,yi] = meshgrid(1:img_size(2),1:img_size(1));

% we'll need to do the foveation procedure 3 times; once for each
% of the three color planes.
for color_idx = 1:3
  img = color_img(:,:,color_idx);
  
  % build Gaussian pyramid
  [pyr,indices] = buildGpyr(img,levels);

  % upsample each level of the pyramid in order to create a
  % foveated representation
  point = 1;
  blurtree = zeros(img_size(1),img_size(2),levels);
  for n=1:levels
    nextpoint = point + prod(indices(n,:)) - 1;
    show = reshape(pyr(point:nextpoint),indices(n,:));
    point = nextpoint + 1;
    blurtree(:,:,n) = ...
	imcrop(upBlur(show, n-1),[1 1 img_size(2)-1 img_size(1)-1]);
  end

  clear pyr indices;
  clear show;
  
  % create foveated image by interpolation
  foveated(:,:,color_idx) = interp3(blurtree,xi,yi,minpyrlevel, '*linear');

end

clear color_img img;
clear xi yi;

% return to RGB representation if we converted to YCbCr
if use_ycbcr == 1
  foveated = ycbcr2rgb(foveated);
end


% readjust the range of the final image in order to ensure values
% 0.0 < foveated(i,j) < 1.0
range = [min(foveated(:)) max(foveated(:))];
foveated = (foveated-range(1)) ./ (range(2) - range(1));
% figure(678);
% imshow(foveated);
frm = im2frame(foveated);
writeVideo(writerObj,frm);

% figure(250);
% imshow(foveated);
% title('~Foveated image');

% write frame out to a tif file:
if(outfile == 1)
  temp_str = sprintf('F%s', file);
  imwrite(foveated,temp_str,'Quality',100);
end
fprintf('Foveating Frame %d is finished\n',frames);
clearvars -except mov inputvideo outputvideo writerObj readerobj vidHeight vidWidth frames ;

end;


  close(writerObj);
  disp('grand success');
  
    



    
