module slave_one(input pclk,presetn,pwrite,psel,penable,output pready,input[31:0]pwdata,paddr,output reg[31:0]prdata);
reg[31:0]dataf;
assign pready = 1'b1; 
always@(posedge pclk or negedge presetn)begin
	if(~presetn)
		dataf <= 0;
	else begin
			if(pwrite == 1 && penable == 1 && psel == 0)
				dataf <= pwdata;
			else if(pwrite == 0 && penable == 1 && psel == 0)
				prdata <= dataf;
	end
end
endmodule


module slave_two(input pclk,presetn,pwrite,psel,penable,output pready,input[31:0]pwdata,paddr,output reg[31:0]prdata);
reg[31:0]dataf;
assign pready = 1'b1; 
always@(posedge pclk or negedge presetn)begin
	if(~presetn)
		dataf <= 0;
	else begin
			if(pwrite == 1 && penable == 1 && psel == 1)
				dataf <= pwdata;
			else if(pwrite == 0 && penable == 1 && psel == 1)
				prdata <= dataf;
	end
end
endmodule



