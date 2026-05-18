module riscvsingle(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr,
    input  logic [31:0] ReadData,
    output logic [31:0] PC,
    output logic [31:0] WriteData,
    output logic [31:0] ALUResult,
    output logic        MemWrite
);
    logic [1:0] PCSrc;
    logic       RegWrite;
    logic [2:0] ImmType;
    logic       ALUSrc;
    logic [2:0] ALUControl;
    logic       Zero;
    logic [1:0] ResultSrc;

    datapath dp (
        .clk, 
        .reset, 
        .instr, 
        .ReadData, 
        .PCSrc, 
        .RegWrite, 
        .ImmType, 
        .ALUSrc, 
        .ALUControl, 
        .ResultSrc,
        .ALUResult,
        .WriteData,
        .PC,
        .Zero
    );

    main_dec m_dec (
        .opcode(instr[6:0]),
        .funct3(instr[14:12]),
        .Zero,
        .PCSrc,
        .ALUSrc,
        .RegWrite,
        .MemWrite,
        .ResultSrc,
        .ImmType
    );

    alu_dec a_dec (
        .funct3(instr[14:12]),
        .funct7(instr[31:25]),
        .opcode(instr[6:0]),
        .ALUControl
    );
endmodule