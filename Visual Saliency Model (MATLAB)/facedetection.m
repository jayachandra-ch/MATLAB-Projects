function[salmap]=facedetection(inputimage)
FDetect = vision.CascadeObjectDetector;
BB = step(FDetect,inputimage);
row=size(BB,1);
x=size(inputimage,1);
y=size(inputimage,2);
salmap=zeros(x,y);
if numel(BB)==1
    salmap=salmap;
else   
for i=1:1:row  
sigmax=(BB(i,3)/6)*2.3;
sigmay=sigmax;
dims = [BB(i,3) BB(i,4)];
P = [round(dims(1)/2) round(dims(2)/2)];
[Xm Ym] = meshgrid(-P(2):P(2), -P(1):P(1)); 
gauss = exp(-((( Xm.^2)./(2*sigmax*sigmax))+(( Ym.^2)./(2*sigmay*sigmay))));
cmaxval=max(max(gauss ));
gauss=(gauss/cmaxval)*255;
firstx=(BB(i,2));
lastx= ((BB(i,2))-1)+size(gauss,1);
firsty=(BB(i,1));
lasty=((BB(i,1))-1)+size(gauss,2);
salmap(firstx:lastx, firsty:lasty)=gauss;
end;
end;
