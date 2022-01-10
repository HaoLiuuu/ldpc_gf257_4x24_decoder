/***************************************************
@File         :  comp2in2out.v
@Author       :  JiangxuanLi 
@DateTime     :  2020/12/12 22:45:28
@Description  :  2 input comparison

****************************************************/

module comp2in2out #(
    parameter WIDTH = 7
)(    
    input  [WIDTH-1:0] in_1         ,
    input  [WIDTH-1:0] in_2         ,
 
    output reg [WIDTH-1:0] min_v    ,
    output reg [WIDTH-1:0] submin_v 
);
    
    always @(*) begin 
        if (in_1 > in_2) begin 
            min_v    = in_2;
            submin_v = in_1;
        end
        else begin 
            min_v    = in_1;
            submin_v = in_2;
        end
    end

endmodule