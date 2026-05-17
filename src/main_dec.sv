module main_dec(
    input  logic [6:0] opcode,
    input  logic [2:0] funct3,
    input  logic       Zero,
    output logic [1:0] PCSrc,
    output logic       RegWrite,
    output logic       ALUSrc,
    output logic       MemWrite,
    output logic [1:0] ResultSrc,
    output logic [2:0] ImmType
);
    always_comb
        case(opcode)
            // lw instruction
            7'b0000011: begin
                PCSrc = '0;
                RegWrite = '1;
                ALUSrc = '1;
                MemWrite = '0;
                ResultSrc = 2'b01;
                ImmType = 3'b001;
            end
            // sw instruction
            7'b0100011: begin
                PCSrc = '0;
                RegWrite = '0;
                ALUSrc = '1;
                MemWrite = '1;
                ResultSrc = '0;
                ImmType = 3'b010;
            end
            // i-type instructions (addi, xori, ori, andi, slti)
            7'b0010011: begin
                PCSrc = '0;
                RegWrite = '1;
                ALUSrc = '1;
                MemWrite = '0;
                ResultSrc = '0;
                ImmType = 3'b001;
            end
            // b-type instructions (beq, bne)
            7'b1100011: begin
                RegWrite = '0;
                ALUSrc = '0;
                MemWrite = '0;
                ResultSrc = '0;
                ImmType = 3'b011;

                case(funct3)
                    // beq
                    3'b000:  PCSrc = {1'b0, Zero};
                    // bne
                    3'b001:  PCSrc = {1'b0, ~Zero};
                    default: PCSrc = '0;
                endcase
            end
            // r-type instructions (add, sub, xor, or, and, slt)
            7'b0110011: begin
                PCSrc = '0;
                RegWrite = '1;
                ALUSrc = '0;
                MemWrite = '0;
                ResultSrc = '0;
                ImmType = '0;
            end
            // jal instruction
            7'b1101111: begin
                RegWrite = '1;
                MemWrite = '0;
                ResultSrc = 2'b10;
                PCSrc = 2'b01;
                ALUSrc = '1;
                ImmType = 3'b100;
            end
            // jalr instruction
            7'b1100111: begin
                RegWrite = '1;
                MemWrite = '0;
                ResultSrc = 2'b10;
                PCSrc = 2'b10;
                ALUSrc = '1;
                ImmType = 3'b001;
            end
            default: begin
                RegWrite = '0;
                MemWrite = '0;
                ResultSrc = '0;
                PCSrc = '0;
                ALUSrc = '0;
                ImmType = '0;
            end
        endcase
endmodule