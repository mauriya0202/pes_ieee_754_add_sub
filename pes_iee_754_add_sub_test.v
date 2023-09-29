module pes_ieee_754_add_sub_test();
reg [31:0]a1,b1;
reg cntl1,clk;
wire [31:0]c;

pes_ieee_754_add_sub DUT(a1,b1,c,cntl1,clk);
initial clk=0;
always #5 clk=~clk;
initial begin
cntl1=1;
a1=32'b01000000100000000000000000000000;//4
b1=32'b01000001000100000000000000000000;//3
#250 $finish;
end
endmodule
