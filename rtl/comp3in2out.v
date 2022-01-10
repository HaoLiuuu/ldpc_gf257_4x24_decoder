/***************************************************
@File         :  comp3in.v
@Author       :  JiangxuanLi 
@DateTime     :  2020/12/12 22:07:54
@Description  :  3 input comparison
                 find min and submin in three

                 full combinational circuit

****************************************************/
//
// 需要考虑一个问题 如果出现值相同的情况 该如何处理
// log:
//      2020/12/13 10:53:42     没有问题 测试可以通过
//
module comp3in2out #(
    parameter WIDTH = 7
)(    
    input  [WIDTH-1:0] in_1         ,
    input  [WIDTH-1:0] in_2         ,
    input  [WIDTH-1:0] in_3         ,
 
    output reg [WIDTH-1:0] min_v    ,
    output reg [WIDTH-1:0] submin_v 
);
    
    wire sig_1 = in_1 < in_2;
    wire sig_2 = in_1 < in_3;
    wire sig_3 = in_2 < in_3;

    // 根据比较结果给出最小值和次小值                           
    // | st | {sig_1, sig_2, sig_3} | min_v  | submin_v |
    // |  1 |        000            | in_3   | in_2     |
    // |  2 |        001            | in_2   | in_3     |  
    // |  3 |        010            | xxxx   | xxxx     |
    // |  4 |        011            | in_2   | in_1     |
    // |  5 |        100            | in_3   | in_1     |
    // |  6 |        101            | xxxx   | xxxx     |
    // |  7 |        110            | in_1   | in_3     |
    // |  8 |        111            | in_1   | in_2     |
    always @(*) begin 
        case ({sig_1, sig_2, sig_3})
            3'b000: begin 
                min_v    = in_3;
                submin_v = in_2;
            end
            3'b001: begin 
                min_v    = in_2;
                submin_v = in_3;
            end
            3'b011:  begin 
                min_v    = in_2;
                submin_v = in_1;
            end
            3'b100: begin 
                min_v    = in_3;
                submin_v = in_1;
            end
            3'b110: begin 
                min_v    = in_1;
                submin_v = in_3;
            end
            3'b111: begin 
                min_v    = in_1;
                submin_v = in_2;
            end
            default : begin 
                min_v    = {WIDTH{1'b1}};
                submin_v = {WIDTH{1'b1}};
            end
        endcase
    end

endmodule