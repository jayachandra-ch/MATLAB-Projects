
 function sam= focusandcenter(image) 
xwidth=0.95;
yheight=xwidth;
focusweight=1.0;

zigzagarray=[1,2,6,7,15,16,28,29;
             3,5,8,14,17,27,30,43;
             4,9,13,18,26,31,42,44;
             10,12,19,25,32,41,45,54;
             11,20,24,33,40,46,53,55;
             21,23,34,39,47,52,56,61;
             22,35,38,48,51,57,60,62;
             36,37,49,50,58,59,63,64];

 pic=image; 
yuv=rgb2hsv(pic);

y=yuv(:,:,3);
[bm bn] = size(y);

r_bm = rem(bm,8);
r_bn = rem(bn,8);

if r_bm~=0 
r_bm=8-r_bm;
else
   r_bm=0; 
end;
if r_bn~=0
    r_bn=8-r_bn;
else
   r_bn=0; 
end;

y = padarray(y, [r_bm r_bn], 0, 'post');

normaldct = blkproc(y,[8 8],'ict');
absolutedct=abs(normaldct);

[maprow mapcol]=size(absolutedct);
maprowl=(maprow/8);
mapcoll=(mapcol/8);

superblock=zeros(8,8);

tcount=0;



for i=1:1:maprowl
    for j=1:1:mapcoll
       
            for m=(8*(i-1)+1):1:(8*(i-1)+8)
                for n=(8*(j-1)+1):1:(8*(j-1)+8)
                    superblock((m-(8*(i-1)+1)+1),(n-(8*(j-1)+1)+1))=superblock((m-(8*(i-1)+1)+1),(n-(8*(j-1)+1)+1))+absolutedct(m,n); 
                    
                end;
            end;
            tcount=tcount+1;
    end;
end;

            
 


[sizerow sizecol]=size(absolutedct);
nblks=((sizerow*sizecol)/64);

imageout=zigzagscan(superblock);
imageout=imageout';
imageout(1:64,2)=imageout(1:64,1);
for m=1:1:64
    imageout(m,1)=m;
end;

[maxtab, mintab] = peakdet(imageout(:,2), 0.0001);

[maxtabrow, maxtabcol]=size(maxtab);

% Exclude some frequency components
%-------------------------------------------------------------------------------------------------------
for i=1:1:maxtabrow
    if (maxtab(i,1)<2) || (maxtab(i,1)>30)
        maxtab(i,1)=0;
    end;
end;
increment=0;
primaryfrequencyvalues=zeros(maxtabrow,1);
for i=1:1:maxtabrow
    if maxtab(i,1)~=0
        increment=increment+1;
        primaryfrequencyvalues(increment,1)=maxtab(i,1);
    end;
end;
nonzerovaluecount=0;
for  i=1:1:maxtabrow
    if primaryfrequencyvalues(i,1)~=0
        nonzerovaluecount=nonzerovaluecount+1;
    end;
end;
    
frequencypositions=zeros(nonzerovaluecount,2);
for i=1:1:nonzerovaluecount
    [frequencypositions(i,1),frequencypositions(i,2)]=find(zigzagarray==primaryfrequencyvalues(i,1));
end;

%-----------------------------------------------------------------------------------------------------------
[fqprow fqpcol]=size(frequencypositions);
%fqprow= round(fqprow/3);
finalarray=zeros(maprowl,mapcoll);
 for i=1:1:maprowl
     for j=1:1:mapcoll
         sum=0;
         for dctsum=1:1:fqprow
 sum=sum+(absolutedct((8*(i-1)+frequencypositions(dctsum,1)),(8*(j-1)+frequencypositions(dctsum,2))));
         end;
        finalarray(i,j)=sum;  
     end;
 end;
 
 
[rowfinalarray colfinalarray] = size(finalarray);

   h=fspecial('gaussian',[12 12],4);
   finalarray=imfilter(finalarray,h,'same','conv');

finalarray= finalarray(:,:)*3.0;
max_val = max(max(finalarray));
for i=1:1:rowfinalarray
    for j=1:1:colfinalarray
        finalarray(i,j) = ((finalarray(i,j) * 255) / max_val);
    end
end

 sigmax= (xwidth*colfinalarray)/6; 
 sigmay= (yheight*rowfinalarray)/6;

dims = [rowfinalarray colfinalarray];
P = [round(dims(1)/2) round(dims(2)/2)];
[Xm Ym] = meshgrid(-P(2):P(2), -P(1):P(1)); 
gauss = exp(-((( Xm.^2)./(2*sigmax*sigmax))+(( Ym.^2)./(2*sigmay*sigmay))));
cmaxval=max(max(gauss ));
gauss=(gauss/cmaxval)*255;

centerweight=1-focusweight;

salmap= focusweight*(finalarray)+centerweight*(double(gauss(1:rowfinalarray,1:colfinalarray)));

 salmap=imresize(salmap,8,'bicubic');
 sam=salmap;



            
  

            
    