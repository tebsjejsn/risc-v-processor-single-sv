module datapath(
    input  logic        clk,
    input  logic        reset,
    input  logic [31:0] instr,
    input  logic [31:0] ReadData,
    input  logic [1:0]  PCSrc,
    input  logic        RegWrite,
    input  logic [2:0]  ImmType,
    input  logic        ALUSrc,
    input  logic [2:0]  ALUControl,
    input  logic [1:0]  ResultSrc,
    output logic [31:0] ALUResult,
    output logic [31:0] WriteData,
    output logic [31:0] PC,
    output logic        Zero
);
    logic [31:0] PCNext;
    logic [31:0] PCPlus4;
    logic [31:0] PCTarget;
    logic [31:0] ImmExt;
    logic [31:0] SrcA;
    logic [31:0] SrcB;
    logic [31:0] Result;
    logic [31:0] aluresult;
    logic [31:0] writedata;
    logic [31:0] pc;

    mux3 #(.width(32)) pcmux (
        .d0(PCPlus4), 
        .d1(PCTarget), 
        .d2(ALUResult), 
        .s(PCSrc), 
        .y(PCNext)
    );
    flopr pcreg (
        .clk, 
        .reset, 
        .d(PCNext), 
        .q(PC)
    );
    adder pc4add (
        .a(PC), 
        .b(8'd00000004), 
        .y(PCPlus4)
    );
    regfile rf (
        .clk, 
        .a1(instr[19:15]), 
        .a2(instr[24:20]), 
        .a3(instr[11:7]), 
        .wd3(Result),
        .we3(RegWrite), 
        .rd1(ScrA), 
        .rd2(WriteData)
    );
    mux2 #(.width(32)) alumux (
        .d0(WriteData), 
        .d1(ImmExt), 
        .s(ALUSrc), 
        .y(SrcB)
    );
    alu alumain (
        .SrcA, 
        .SrcB, 
        .ALUControl, 
        .Zero, 
        .ALUResult
    );
    extend ext (
        .instr(instr[31:7]), 
        .immtype(ImmType), 
        .immext(ImmExt)
    );
    adder pctargetadd (
        .a(PC), 
        .b(ImmExt), 
        .y(PCTarget)
    );
    mux3 #(.width(32)) resultmux (
        .d0(ALUResult), 
        .d1(ReadData), 
        .d2(PCPlus4), 
        .s(ResultSrc), 
        .y(Result)
    );
endmodule