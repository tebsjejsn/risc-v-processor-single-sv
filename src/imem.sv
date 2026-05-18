module imem(
    input  logic [31:0] A,
    output logic [31:0] rd
);
    typedef logic [31:0] ramtype [255:0];
    ramtype mem;

    // add appropriate text file
    initial $readmemh("riscvtest.txt", mem);

    assign rd = mem[A[31:2]];
endmodule