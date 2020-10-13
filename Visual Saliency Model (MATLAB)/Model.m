function Model(inputimage)
image=imread(inputimage);
Combinedmap=focusandcenter(image);
 facemap=facedetection(image);
saliencymap=Overlay(facemap,Combinedmap);
I=mat2gray(saliencymap,[0 255]);
filename=strcat('saliencymap','.bmp');
imwrite(I,filename,'bmp');
end
