一些在后续需要确定的小问题：

---

## ldpc_cpu.v

`PIPE_DELAY` 具体是多少，7 或者 6，需要根据后续的仿真确定，这似乎会有一系列的连锁反应，在最后写顶层模块的时候还是需要考虑这个问题。

![image-20220110195941215](D:\Documents\LDPC\ldpc_gf257_4x24_decoder\doc\ATTENTIONS.assets\image-20220110195941215.png)

---

## ldpc_vpu.v

![image-20220110195709208](D:\Documents\LDPC\ldpc_gf257_4x24_decoder\doc\ATTENTIONS.assets\image-20220110195709208.png)

---

## ELSE

要进行加法的位扩展的话，是不是用 S-M 的格式更好呢？我开始犹豫了，如果更好的，我们之前的转换就显得有些多余了。


---

写地址不能由生成地址延时得到，另外生成一套地址。
