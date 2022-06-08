/*
 由於 branch 和 jump 指令會造成 control hazard
 因此我們新增一個 control unit 用來解決這個問題
 如果要branch 的話，flush 掉 branch 指令之後進來的指令
*/

module ctrl(
    input wire rst_i,
    input wire clk_i,

    //from ex
    input wire jumpe_i,
    // to if_id
    output reg if_id_flush,
    // to id_exe
    output reg id_exe_flush,
    // to exe_mem
    output reg exe_mem_flush,
    // to pc_reg
    output reg jumpe_o
);
    always @(posedge clk_i) begin
        if (jumpe_i == `JumpEnable) begin
            jumpe_o <= jumpe_i;
            if_id_flush <= `FlushEnable;
            id_exe_flush <= `FlushEnable;
            exe_mem_flush <= `FlushEnable;
        end else begin
            jumpe_o <= jumpe_i;
            if_id_flush <= `FlushDisable;
            id_exe_flush <= `FlushDisable;
            exe_mem_flush <= `FlushDisable;
        end
    end

endmodule