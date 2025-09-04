module tb;

reg clock = 0;
always #5 clock = ~clock; 

// top dut(.clk(clk), .sys_rst(0), .din(15'b000000000000000), .dout(out));
top dut(clock);

integer i = 0;

initial
begin
   for(i=0;i<32;i=i+1)
   begin
      dut.GPR[i] = i;
   end
end



 
endmodule