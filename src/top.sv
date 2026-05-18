module top(
    input  logic        clk,
    input  logic        reset,
    output logic [31:0] WriteData,
    output logic [31:0] dataAdr,
    output logic        MemWrite
);
    logic [31:0] PC;
    logic [31:0] instr;
    logic [31:0] ReadData;

    riscvsingle riscv (
        .clk, 
        .reset,
        .PC,
        .instr,
        .WriteData,
        .ALUResult(dataAdr),
        .ReadData,
        .MemWrite
    );

    imem imem1 (
        .A(PC),
        .rd(instr)
    );

    dmem dmem1 (
        .A(dataAdr),
        .wd(WriteData),
        .clk,
        .MemWrite,
        .ReadData
    );
endmodule