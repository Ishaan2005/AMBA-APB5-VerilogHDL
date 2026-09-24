module master(pclk,presetn,pready,ptransfer,pslverr,pwrite,psel,penable,paddr,pwdata,prdata);
input pclk,presetn,pready,ptransfer,pslverr;
output reg pwrite,psel,penable;
output reg[31:0]paddr,pwdata;
input[31:0]prdata;
 //The first [31:0] describes the width of each register, 
							 //while the second [31:0] describes the number of elements (32)
							 
localparam idle = 2'b00;
localparam setup = 2'b01;
localparam access = 2'b10;
reg[1:0]ps,ns;

always@(posedge pclk or negedge presetn)begin //active low reset in apb, also async here 
	if(~presetn)
		ps <= idle;
	else
		ps <= ns;		
end

always@(*)begin
ns = ps;
psel = 1'b0;
penable = 1'b0;

	case(ps)
	
		idle:begin
			if(ptransfer)
				ns = setup;
			else
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
