
// $Revision: #1 $
// $Date: 2020/08/12 $
// $Author: zhlw  $

// -----------------------------------------------
// Reset Synchronizer
// -----------------------------------------------
`timescale 1 ns / 1 ns

module reset_syn
#(
    parameter GLOBLE_EN   = 0,
    parameter ASYNC_RESET = 1,
    parameter DEPTH       = 2
)
(
    input   reset_in /* synthesis ALTERA_ATTRIBUTE = "SUPPRESS_DA_RULE_INTERNAL=R101" */,

    input   clk,
    output  reset_out
);


    // -----------------------------------------------
    // Synchronizer register chain. We cannot reuse the
    // standard synchronizer in this implementation 
    // because our timing constraints are different.
    //
    // Instead of cutting the timing path to the d-input 
    // on the first flop we need to cut the aclr input.
    // 
    // We omit the "preserve" attribute on the final
    // output register, so that the synthesis tool can
    // duplicate it where needed.
    // -----------------------------------------------
    (*ASYNC_REG = "TRUE"*) reg [DEPTH-1:0] rst_syn_chain;
    reg rst_syn_chain_out;

    generate if (ASYNC_RESET) begin

        // -----------------------------------------------
        // Assert asynchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk or posedge reset_in) begin
            if (reset_in) begin
                rst_syn_chain <= {DEPTH{1'b1}};
                rst_syn_chain_out <= 1'b1;
            end
            else begin
                rst_syn_chain[DEPTH-2:0] <= rst_syn_chain[DEPTH-1:1];
                rst_syn_chain[DEPTH-1] <= 1'b0;
                rst_syn_chain_out <= rst_syn_chain[0];
            end
        end
     
    end else begin

        // -----------------------------------------------
        // Assert synchronously, deassert synchronously.
        // -----------------------------------------------
        always @(posedge clk) begin
            rst_syn_chain[DEPTH-2:0] <= rst_syn_chain[DEPTH-1:1];
            rst_syn_chain[DEPTH-1] <= reset_in;
            rst_syn_chain_out <= rst_syn_chain[0];
        end
 
    end
    endgenerate
    
generate 
      if (GLOBLE_EN) begin
       BUFG BUFG_inst (
            .O       (reset_out        ), // 1-bit output: Clock output
            .I       (rst_syn_chain_out)  // 1-bit input: Clock input
             );
      end 
      else begin
         assign reset_out = rst_syn_chain_out;
      end 
endgenerate      
      

endmodule

