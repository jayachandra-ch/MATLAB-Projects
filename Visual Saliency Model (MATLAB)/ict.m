function [W]= ict(X)

C= [1,1,1,1,1,1,1,1;
   1.5,1.25,0.75,0.375,-0.375,-0.75,-1.25,-1.5;
   1,0.5,-0.5,-1,-1,-0.5,0.5,1;
   1.25,-0.375,-1.5,-0.75,0.75,1.5,0.375,-1.25;
   1,-1,-1,1,1,-1,-1,1;
   0.75,-1.5,0.375,1.25,-1.25,-0.375,1.5,-0.75;
   0.5,-1,1,-0.5,-0.5,1,-1,0.5;
   0.375,-0.75,1.25,-1.5,1.5,-1.25,0.75,-0.375];
W=(double(C)*double(X)*double(C'));
