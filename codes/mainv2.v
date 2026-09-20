				ns = idle;
		end
		
		setup:begin
				ns = access;
				psel = 1'b1;
		end
		
		access:begin
		psel = 1'b1;
		penable = 1'b1;
			if(pready == 1 && ptransfer == 0)
				ns = idle;
			else if(pready == 1 && ptransfer == 1)
				ns = setup;
			else
				ns = access;	
		end
		
		default: ns = idle;
		
	endcase		
end
endmodule

module slave(input pclk,presetn,pwrite,psel,penable,output pready,input[31:0]pwdata,paddr,output reg[31:0]prdata);
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
