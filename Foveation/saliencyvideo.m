clc;
clear all;
outputvideo = 'tractorsaliencyvideo.avi';
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
% imshow(out);

writeVideo(writerObj,out);
fprintf('frame %d is finished\n',frames);
end;

 close(writerObj);
  disp('grand success');
