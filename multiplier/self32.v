/*
先決條件：這裡不管 adder 是使用 RCA 還是 carry look ahead，因為太複雜了。所以直接讓 verilog 自己做加法。

實現結果：有號的數字相乘，使用循序電路實做，非邏輯電路。

想法：將所有數字轉換回正數後相乘，最後在依照結果決定要不要做補數。

優點：簡單易懂

缺點：相較 booth's 演算法較沒有效率。相較邏輯電路更慢。

改進：應該有辦法跳過 bit 是 0 的位元做運算，這樣就不用 16 個 clock 了。
    實際運作的地方大兩使用到 blocking statement，可能有改進的地方。
*/
`include "defines.v"

module Multiplier(
    input wire clk,
    input wire rst,
    input wire[15:0] A_i,
    input wire[15:0] B_i,

    output reg[31:0] C_o
);
    reg[15:0] A_comp, B_comp;
    reg[3:0] counter;
    reg[15:0] adder_o;
    reg complete;

    always @(posedge clk) begin
        /* 決定要不要補數 */
        if(A_i[15] == 1) begin
            A_comp = ~A_i + 1;
        end else begin
            A_comp = A_i;
        end

        if(B_i[15] == 1) begin
            B_comp = ~B_i + 1;
        end else begin
            B_comp = B_i;
        end

        /* 乘法器運實際運作的地方，大量運用到 blocking statement */
        if (rst == `RstEnable) begin
            C_o <= 32'h0;
            adder_o <= 16'h0;
            counter <= 4'h0;
            complete <= 1'b0;
        end else if(complete == 0) begin
            if(counter == 0) begin
                C_o <= {{16{1'b0}}, B_comp};
                counter <= counter + 1;
            end else begin
                adder_o = (A_comp & {16{C_o[0]}}) + C_o[31:16];
                C_o[31:16] = adder_o;
                C_o = C_o >> 1;

                if(counter == 4'hf) begin
                    complete = 1'b1;
                    C_o = C_o >> 1;
                    if(A_i[15] ^ B_i[15]) begin
                        C_o = ~C_o + 1;
                    end else begin
                        C_o = C_o;
                    end
                end else begin
                    counter = counter + 1;
                end
            end
        end else begin
            complete <= complete;
            counter <= counter;
            adder_o <= adder_o;
        end
    end

endmodule