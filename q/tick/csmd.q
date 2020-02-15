/本脚本仅供学习之用。

/要订阅的证券代码（Wind格式）;数量不能太多，否则可能被服务器禁用
codes: `000001.SH`600036.SH`000001.SZ`399001.SZ; 

/sina代码格式转换：`shxxxxxx => `xxxxxx.SH, `szxxxxxx=>`xxxxxx.SZ : sinacode2sym[`sh600036]   sinacode2sym[`sh000001]
sinacode2sym:{`$$["sh"~2#sx:string x;(2_sx),".SH";"sz"~2#sx;(2_sx),".SZ";sx]};   

/sina代码格式转换：`xxxxxx.SH => `shxxxxxx, `xxxxxx.SZ => `szxxxxxx :  sym2sinacode[`000001.SH]   sym2sinacode[`000001.SZ]
sym2sinacode:{`$$[".SH"~-3#sx:string x;"sh",-3_sx;".SZ"~-3#sx;"sz",-3_sx;sx]};

/连接到sina websocket:如果采用wss协议则需要设置环境变量set SSL_VERIFY_SERVER=NO且存在libeay32.dll/ssleay32.dll
conn2ws:{[codes]:(`$":wss://hq.sinajs.cn")"GET /wskt?list=",("," sv string sym2sinacode each codes)," HTTP/1.1\r\nHost: hq.sinajs.cn\r\n\r\n";};

/将接收到的字符串解析为表
str2tbl:{select date,`timespan$time,{sinacode2sym`$vs["=";string x]0}each sym,prevclose,open,high,low,close,volume,amount,bid,bsize,ask,asize from 
 flip ( `sym`open`prevclose`close`high`low`bid0`ask0`volume`amount`bsize`bid`bsize2`bid2`bsize3`bid3`bsize4`bid4`bsize5`bid5`asize`ask`asize2`ask2`asize3`ask3`asize4`ask4`asize5`ask5`date`time)!("S",(29#"F"),"DT";",")0: "\n" vs -1 _ x};

/定义行情表（主键表），用于保存最新行情 
cstaq:([sym:`$()]date:`date$();time:`timespan$();prevclose:`float$();open:`float$();high:`float$();low:`float$();close:`float$();volume:`float$();amount:`float$();bid:`float$();bsize:`float$();ask:`float$();asize:`float$());

/连接tickerplant
h:hopen `::5010;

/定议.z.ws函数，处理websocket返回的数据
.z.ws:{`cstaq upsert t:str2tbl x;
 {neg[h](`.u.upd;`cstaq;value x)}each 
  delete date from select from t where date=.z.D;};

/连接websocket 
wsh:conn2ws[codes];

/定时器，发送心跳
.z.ts:{neg[wsh 0] "";};
system "t 10000";
