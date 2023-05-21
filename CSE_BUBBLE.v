/*
############################################################################################
ASSIGNMENT 7 - PROCESSOR DEVELOPMENT
############################################################################################
AUTHORS
----------------------------
DIVYANSH - 210355
DIVYANSH CHHABRIA - 210356
----------------------------
############################################################################################
*/

// TESTBENCH MODULE
module testbench();


// DEFINING INPUTS AND OUTPUTS FOR THE INSTRUCTION_DECODER_MODULE
reg clock;
reg reset_VM;
reg [4:0] address_VM;
reg mode_VM;
reg [31:0] datain_VM;
reg is_instruction_stored;
wire [31:0] dataout_VM;

// CHANGING CLOCK SIGNAL EVERY 5 UNIT OF TIME
always #5 clock = ~clock;

// INSTANTIATING THE INSTRUCTION_DECODER MODULE
Instruction_Decoder i1 (clock,reset_VM,address_VM,datain_VM,mode_VM,dataout_VM,is_instruction_stored);


initial begin

    $dumpvars;
    clock <= 0;
    reset_VM <= 0;

    // INSTRUCTIONS HAVE NOT BEEN STORED
    is_instruction_stored <= 0;

    // DETAILS FOR THESE INSTRUCTIONS IS GIVEN IN A SEPEARTE FILE

    // STORING INSTRUCTIONS IN THE VEDA MEMORY FOR BUUBLE SORT
    #10
    datain_VM <= 32'b001000_11111_11111_0000000000000001;
    address_VM <= 0;
    mode_VM <= 1;

    #10
    datain_VM <= 32'b100100_00000_00000_0000000000000000;
    address_VM <= 1;
    mode_VM <= 1;

    #10
    datain_VM <= 32'b000000_00000_00010_00100_00000_100010;
    address_VM <= 2;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000000_00011_00011_00011_00000_100010;
    address_VM <= 3;
    mode_VM <= 1;

    #10
    datain_VM <= 32'b001000_00011_00101_0000000000000001;
    address_VM <= 4;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b100011_00011_00110_0000000000000000;
    address_VM <= 5;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b100011_00101_00111_0000000000000000;
    address_VM <= 6;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000000_00110_00111_01000_00000_101010;
    address_VM <= 7;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000100_11111_01000_0000000000001011;
    address_VM <= 8;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b101100_00011_00111_0000000000000000;
    address_VM <= 9;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b101100_00101_00110_0000000000000000;
    address_VM <= 10;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b001000_00011_00011_0000000000000001;
    address_VM <= 11;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000000_00011_00100_01001_00000_101010;
    address_VM <= 12;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000101_11111_01001_0000000000001111;
    address_VM <= 13;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000010_00000000000000000000000100;
    address_VM <= 14;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b001000_00010_00010_0000000000000001;
    address_VM <= 15;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000000_00010_00000_01010_00000_101010;
    address_VM <= 16;
    mode_VM <= 1;
    
    #10
    datain_VM <= 32'b000100_11111_01010_0000000000000010;
    address_VM <= 17;
    mode_VM <= 1;

    // TOGGLE THE PARAMETER TO CHECK IF THE INSTRUCTIONS ARE STORED
    #10 is_instruction_stored <= 1;
    
    #5000 $finish;

end
endmodule



module Instruction_Decoder(clock,reset_VM,address_VM,datain_VM,mode_VM,dataout_VM,is_instruction_stored);

// ###################################### CODE FOR VEDA MEMORY STARTS################################################# 

reg [31:0] VedaMemoryForInstructions [17:0];

input [4:0] address_VM;
input [31:0] datain_VM;
input clock,reset_VM,mode_VM;
input is_instruction_stored;
output reg [31:0] dataout_VM;

always@(posedge clock)
begin
if (reset_VM)
	begin:abs
		integer i;
		for(i=0;i<32;i=i+1)
		begin
			VedaMemoryForInstructions[i]<=32'b0;
		end
	end
end

always@(posedge clock)
begin
  if (is_instruction_stored == 1'b0)
  begin
    if (mode_VM) VedaMemoryForInstructions[address_VM] <= datain_VM; 
    else dataout_VM <= VedaMemoryForInstructions[address_VM];
  end
end

// ########################################### CODE FOR VEDA MEMORY ENDS #################################################

// DECLARING THE PROGRAM COUNTER
reg [31:0] PC;

// DECLARING VARIABLE FOR A PARTICULAR INSTRUCTION
reg [31:0] instruction;


// #################################################
// DECLARING WORKING SEGMENTS OF INSTRUCTION

// common for all types
reg [5:0]op_code;

// for R type
reg [5:0]func_code;
reg [4:0]rs;
reg [4:0]rt;
reg [4:0]rd;
reg [4:0]shamt;

// for J type
reg [25:0] address;

// for I type
reg [15:0] imm;

// ####################################################


// DECLARING THE REGISTER FILES
reg [31:0]R[31:0];

// DECLARING THE DATA MEMORY
reg [31:0]Data[31:0];

// DECLARING VARIABLES TO CHECK THE TYPE OF INSTRUCTION
reg [1:0] is_rtype;
reg [1:0] is_itype;
reg [1:0] is_jtype;

// DECLARING VARIABLES TO SHOW THE VALUES OF R[rs], R[rt], R[rd] AT PRESENT VALUES OF rs, rt, rd
reg [31:0] register_rt;
reg [31:0] register_rs;
reg [31:0] register_rd;

// DECLARING INTEGER I - USED IN ALWAYS BLOCK
integer i = 0;

// DECLARING THE DATA VARIABLES SO THAT THE CAN BE VISUALIZED IN TESTBENCH
reg[31:0] data_0,data_1,data_2,data_3,data_4,data_5,data_6;

// THESE REG WERE USED FOR DEBUGGING PURPOSES---CAN BE IGNORED
reg [31:0] i_iterator;
reg [31:0] j_iterator;
reg [31:0] n;
reg [31:0] n_minus_one;
reg [31:0] r1;


initial begin
  // INITIALIZE INSTRUCTION VARIABLE EITH FIRST INSTRUCTION
  instruction = VedaMemoryForInstructions[0];
  for(i=0;i<32;i=i+1)
  // INITIALIZE THE REGISTER FILES AND DATA MEMORY WITH ZEROS
  begin
    R[i] = 32'b0;
    Data[i] = 32'b0;
  end

  // INITIALIZE THE DATA MEMORY FOR TESTING BUBBLE SORT
  n = 7;
  Data[0] = 5;
  Data[1] = 10;
  Data[2] = 7;
  Data[3] = 1;
  Data[4] = 16;
  Data[5] = 8;
  Data[6] = 3;

  // INITIALIZE THE PROGRAM COUNTER WITH ZERO
  PC=32'b0; 
end

always@(posedge clock)
begin

  // BEGIN WHEN THE INSTRUCTIONS HAVE BEEN STORED
  if (is_instruction_stored)
  begin
  
    // ASSIGNING VALUES TO REG VARIABLES CREATED ABOVE
    data_0 = Data[0];
    data_1 = Data[1];
    data_2 = Data[2];
    data_3 = Data[3];
    data_4 = Data[4];
    data_5 = Data[5];
    data_6 = Data[6];

    // DEBUGGING PURPOSE -- CAN BE IGNORED
    i_iterator = R[2];
    j_iterator = R[3];
    n_minus_one = n-1;
    r1 = R[0];

    case (PC>>2)
    // SELECTING WHICH INSTRUCTION TO PICK DEPENDING ON VALUE OF PROGRAM COUNTER
      0: instruction = VedaMemoryForInstructions[0];
      1: instruction = VedaMemoryForInstructions[1];
      2: instruction = VedaMemoryForInstructions[2];
      3: instruction = VedaMemoryForInstructions[3];
      4: instruction = VedaMemoryForInstructions[4];
      5: instruction = VedaMemoryForInstructions[5];
      6: instruction = VedaMemoryForInstructions[6];
      7: instruction = VedaMemoryForInstructions[7];
      8: instruction = VedaMemoryForInstructions[8];
      9: instruction = VedaMemoryForInstructions[9];
      10: instruction = VedaMemoryForInstructions[10];
      11: instruction = VedaMemoryForInstructions[11];
      12: instruction = VedaMemoryForInstructions[12];
      13: instruction = VedaMemoryForInstructions[13];
      14: instruction = VedaMemoryForInstructions[14];
      15: instruction = VedaMemoryForInstructions[15];
      16: instruction = VedaMemoryForInstructions[16];
      17: instruction = VedaMemoryForInstructions[17];
      default: instruction = VedaMemoryForInstructions[0];
    endcase

    // INCREMENTING THE PROGRAM COUNTER
    PC = PC + 4;

    // SEGMENTING THE PARTS OF INSTRUCTION
    op_code = instruction[31:26];
    rs = instruction[25:21];
    rt = instruction[20:16];
    rd = instruction[15:11];
    shamt = instruction[10:6];
    func_code = instruction[5:0];
    address = instruction[25:0];
    imm = instruction[15:0];

    // ###################### ALU STARTS HERE ###################################################
    // ------------------------------------------------------------
    // ################### R-type instruction #####################
    if (op_code == 0) 
    begin

      is_rtype = 1;
      is_itype = 0;
      is_jtype = 0;

      register_rd = R[rd];
      register_rs = R[rs];
      register_rt = R[rt];

      // instruction : sll 
      if (func_code == 0)
      begin
        R[rt] = R[rd]<<shamt;
      end

      // instruction : srl 
      else if (func_code == 2)
      begin
        R[rt] = R[rd]>>shamt;
      end

      // instruction : jr 
      else if (func_code == 8)
      begin
        PC = R[rs];
      end

      // instruction : add 
      else if (func_code == 32)
      begin
        R[rd] = R[rs] + R[rt];
      end

      // instruction : addu 
      else if (func_code == 33)
      begin
        R[rd] = R[rs] + R[rt];
      end

      // instruction : sub 
      else if (func_code == 34)
      begin
        R[rd] = R[rs] - R[rt];
      end

      // instruction : subu
      else if (func_code == 35)
      begin
        R[rd] = R[rs] - R[rt];
      end

      // instruction : and
      else if (func_code == 36)
      begin
        R[rd] = R[rs] & R[rt];
      end

      // instruction : or
      else if (func_code == 37)
      begin
        R[rd] = R[rs] | R[rt];
      end

      // instruction : slt
      else if (func_code == 42)
      begin
        R[rd] = R[rs] < R[rt];
      end
    end

    //---------------------------------------------------------------------  
    else 

    // ################# j-type instructions ###############################
    begin


      register_rs = R[rs];
      register_rt = R[rt];

      if (op_code == 2)
      // instruction is 'j'
      begin
        is_rtype = 0;
        is_itype = 0;
        is_jtype = 1;
        PC = {4'b000, address, 2'b00};
      end

      else if (op_code == 3)
      // instruction is 'jal'
      begin

        // ra
        R[31] = PC + 4;
        is_rtype = 0;
        is_itype = 0;
        is_jtype = 1;
        PC = {PC[31:28], address, 2'b00};
      end
      // -----------------------------------------------------------------------

      // ################## i-type instructions ################################

      // instruction : beq
      else if (op_code == 04)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        if (R[rs] == R[rt])
        begin
          PC = {14'b0,imm,2'b00};
        end
      end

      // instruction : bne
      else if (op_code == 5)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        if (R[rs] != R[rt])
        begin
          PC = {14'b0,imm,2'b00};
        end
      end

      // instruction : addi
      else if (op_code == 08)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = R[rs] + imm; 
      end

      // instruction : addui
      else if (op_code == 09)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = R[rs] + imm; 
        
      end

      // instruction : slti
      else if (op_code == 10)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = R[rs] < imm; 
      end

      // instruction : andi
      else if (op_code == 12)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = R[rs] & imm; 
        
      end

      // instruction : ori
      else if (op_code == 13)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = R[rs] | imm; 
        
      end

      // instruction : lw
      else if (op_code == 34)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = Data[rs + imm];
      end

      // instruction : sw
      else if (op_code == 43)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        Data[rs + imm] = R[rt];
      end

      // instruction : lw from address as rs
      else if (op_code == 35)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = Data[R[rs]];
      end

      // instruction : lw from address as rs
      else if (op_code == 36)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        R[rt] = n_minus_one;
      end

      // instruction : sw at address as rs
      else if (op_code == 44)
      begin
        is_rtype = 0;
        is_itype = 1;
        is_jtype = 0;
        Data[R[rs]] = R[rt];
      end
    end
    // ################################################# ALU ENDS HERE ###########################################
  end
  end
endmodule