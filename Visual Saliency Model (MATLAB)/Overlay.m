function[salmap]=Overlay(facemap,Combinedmap)
facemap=imresize(facemap,size(Combinedmap));
salmap=facemap+Combinedmap;
end
