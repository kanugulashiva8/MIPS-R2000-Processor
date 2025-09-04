`timescale 1ns / 1ps

`define op IR[31:26]
`define rs IR[25:21]
`define rt IR[20:16]
`define rd IR[15:11]
`define shamt IR[10:6]
`define funct IR[5:0]
`define immed IR[15:0]
`define target_addr IR[25:0]

`define add 6'b000000
`define sub 6'b000001
`define addi 6'b000010
`define and 6'b000011
`define or 6'b000100
`define andi 6'b000101
`define ori 6'b000110
`define sll 6'b000111
`define srl 6'b001000
`define lw 6'b001001
`define sw 6'b001010
`define beq 6'b001011
`define bne 6'b001100
`define j 6'b001110


module top(
      input clk    
);
     reg [31:0] IR_o, IR;
     reg [15:0] GPR[31:0];
     //reg [15:0] SGPR;
     reg [3:0] PC_i, PC_o, PC;
     wire [3:0] PC_x;
     wire [31:0] IR_x;
     reg [31:0] inst_mem [15:0]; ////program memory
     //reg [15:0] data_mem [15:0]; ////data memory
     
     initial begin
     PC_i = 4'b1111;
     end
     
     instruction_fetch i_f(clk, PC_i, PC_x, IR_x);
     
     always@(PC_x, IR_x)
     begin
        PC <= PC_x;
        IR <= IR_x;
     end
     
     always@(PC)
     begin
        #1 PC_i = PC;
     end
     
     always@(IR)
        begin
           case(`op)
           `add : begin
                     GPR[`rd] = GPR[`rs] + GPR[`rt];
                  end
           `sub : begin
                     GPR[`rd] = GPR[`rs] - GPR[`rt];
                  end       
           `addi : begin
                     GPR[`rs] = GPR[`rt] + `immed;
                  end 
                
           `and : begin
                     GPR[`rd] = GPR[`rs] & GPR[`rt];
                  end  
           `or : begin
                     GPR[`rd] = GPR[`rs] | GPR[`rt];
                  end 
           `andi : begin
                     GPR[`rs] = GPR[`rt] & `immed;
                  end 
           `ori : begin
                     GPR[`rd] = GPR[`rs] | `immed;
                  end
           `sll : begin
                     GPR[`rd] = GPR[`rs] << `immed;
                  end
           `srl : begin
                     GPR[`rd] = GPR[`rs] >> `immed;
                  end  
           `lw : begin
                     GPR[`rd] = GPR[`rs + `immed];
                  end 
           `sw : begin
                     GPR[`rt + `immed] = GPR[`rs];
                  end  
           `beq: begin
                     if(GPR[`rs] == GPR[`rt]) begin
                         PC = PC + `immed;
                     end   
                 end 
           `bne: begin
                     if(GPR[`rs] !== GPR[`rt]) begin
                        PC = PC + `immed;
                     end
                 end                                                                  
           endcase       
        end   
             
endmodule

module instruction_fetch(input clk, input [3:0] PC, output reg [3:0] PC_o, 
                         output reg [31:0] IR);
     reg [31:0] inst_mem [15:0];
                         
     initial begin
     $readmemb("data.mem",inst_mem);
     end
     
     always@(posedge clk)
     begin
        if(inst_mem[PC+1][31:26] == 6'b001110)
        begin
           PC_o = PC + inst_mem[PC+1][25:0] + 1'b1;
           IR = inst_mem[PC_o];
        end
        
        else
        begin
           PC_o = PC + 1'b1;
           IR = inst_mem[PC_o];
        end
     end                    
endmodule