//==============================================================================
// @File         :  comp3in1out.v
// @Author       :  JiangxuanLi 
// @DateTime     :  2020/12/13 20:02:29
// @Description  :  比较器 输出三个数中的最小值

//==============================================================================

module comp3in1out #(
    parameter WIDTH = 7
)(    
    input  [WIDTH-1:0] in_1         ,
    input  [WIDTH-1:0] in_2         ,
    input  [WIDTH-1:0] in_3         ,
 
    output reg [WIDTH-1:0] min_v    
);
    
    wire sig_1 = in_1 < in_2;
    wire sig_2 = in_1 < in_3;
    wire sig_3 = in_2 < in_3;

    // 根据比较结果给出最小值和次小值                           
    // | st | {sig_1, sig_2, sig_3} | min_v  |
    // |  1 |        000            | in_3   |
    // |  2 |        001            | in_2   |
    // |  3 |        010            | xxxx   |
    // |  4 |        011            | in_2   |
    // |  5 |        100            | in_3   |
    // |  6 |        101            | xxxx   |
    // |  7 |        110            | in_1   |
    // |  8 |        111            | in_1   |
    always @(*) begin 
        case ({sig_1, sig_2, sig_3})
            3'b000: begin 
                min_v    = in_3;
            end
            3'b001: begin 
                min_v    = in_2;
            end
            3'b011:  begin 
                min_v    = in_2;
            end
            3'b100: begin 
                min_v    = in_3;
            end
            3'b110: begin 
                min_v    = in_1;
            end
            3'b111: begin 
                min_v    = in_1;
            end
            default : begin // 默认输出全 1
                min_v    = {WIDTH{1'b1}};
            end
        endcase
    end

endmodule