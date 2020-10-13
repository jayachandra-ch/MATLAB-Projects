function out=zigzagscan(in)
[num_rows num_cols]=size(in);
out=zeros(1,num_rows*num_cols);
cur_row=1;	cur_col=1;	cur_index=1;
while cur_row<=num_rows && cur_col<=num_cols
    if cur_row==1 && mod(cur_row+cur_col,2)==0 && cur_col~=num_cols
        out(cur_index)=in(cur_row,cur_col);
		cur_col=cur_col+1;							
		cur_index=cur_index+1;		
	    elseif cur_row==num_rows && mod(cur_row+cur_col,2)~=0 && cur_col~=num_cols
		out(cur_index)=in(cur_row,cur_col);
		cur_col=cur_col+1;							
		cur_index=cur_index+1;		
	    elseif cur_col==1 && mod(cur_row+cur_col,2)~=0 && cur_row~=num_rows
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;							
		cur_index=cur_index+1;		
	    elseif cur_col==num_cols && mod(cur_row+cur_col,2)==0 && cur_row~=num_rows
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;							
		cur_index=cur_index+1;		
	    elseif cur_col~=1 && cur_row~=num_rows && mod(cur_row+cur_col,2)~=0
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row+1;		cur_col=cur_col-1;	
		cur_index=cur_index+1;		
	    elseif cur_row~=1 && cur_col~=num_cols && mod(cur_row+cur_col,2)==0
		out(cur_index)=in(cur_row,cur_col);
		cur_row=cur_row-1;		cur_col=cur_col+1;	
		cur_index=cur_index+1;		
	    elseif cur_row==num_rows && cur_col==num_cols	
        out(end)=in(end);							
		break
    end;
end;