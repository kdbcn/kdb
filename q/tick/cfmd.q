//kdb+CTP行情接口 感谢itfin/zhu honghai/...

//1.配置行情接口信息
/qctpmdinfo:`front`front2`broker`user`pwd!(`tcp://180.168.146.187:10110;`;`9999;`;`); //标准CTP(交易时间用)
qctpmdinfo:`front`front2`broker`user`pwd!(`tcp://180.168.146.187:10131;`;`9999;`;`); //7*24小时环境

//2.修改where条件配置要订阅的代码
getcfsyms:{symsmap::1!select exsym,sym from {update {`$string[x]_2}each exsym from x where ex=`CZC} getwebfutsyms[];
	.ctpmd.sub_syms::exec sym from select sym from symsmap where (sym like "RB[0-9]*.SHF")|(sym like "[IJ][0-9]*.DCE")|(sym like "AP[0-9]*.CZC");
	};  


//=============================期货合约代码转换公式=============================
ctpexsym2sym:{[exsym]:symsmap[exsym;`sym];};  
ctpsym2exsym:{[x]:exec first exsym from select exsym from symsmap where sym=x;}; 
//从新浪读取期货合约代码
getwebfutsyms:{ht:.Q.hg`$":http://finance.sina.com.cn/iframe/futures_info_cff.js";
 :{update exsym:?[ex in`DCE`SHF;lower exsym;exsym],sym:(`$string[exsym],'".",/:string[ex]) from select ex,exsym,name from delete from x where (exsym in`NULL`SHF`DCE`CZC`CFE)or(name=`$"\272\317\324\274")or(name like "*\301\254\320\370")}{update ex:fills?[exsym in`SHF`DCE`CZC`CFE;exsym;`] from x} 
 flip`name`exsym!flip{$[x like "*new Array(*";{`$"," vs {ssr[x;"\"";""]} -2 _ (2+x ? "(")_ x} x;x like "*\311\317\306\332\313\371*";`SHF;x like "*\264\363\311\314\313\371*";`DCE;x like "*\326\243\311\314\313\371*";`CZC;x like "*\326\320\275\360\313\371*";`CFE;`NULL]}each  ";" vs ht};  
//==============================================================================
\c 100 150
.ctpmd.flow:`$ssr[getenv`qhome;"\\";"/"],"/../data/temp/";
sv[`;(hsym[.ctpmd.flow];`null)] set (); /在流文件路径写一个文件，以确保该路径已存在，否则api初始化时会出错
if[not system"p";system"p 5014"];
upd:()!();
.q.showmsg:showmsg:{0N!(x;.z.Z);};
h:neg hopen `::5010;if[h=0;showmsg`tickerplant_conn_error];showmsg(`connect_to_tickerplant;h);
cftaq:([sym:`$()]date:`date$();time:`timespan$();prevclose:`float$();open:`float$();high:`float$();low:`float$();close:`float$();volume:`float$();amount:`float$();openint:`float$();bid:`float$();bsize:`float$();ask:`float$();asize:`float$();upperlimit:`float$();lowerlimit:`float$());
CTPCtrl:(`u#enlist `)!(enlist ());  /保存状态
L12:L11:L:();
`initctpq`freectpq`ctpqrun`userLoginQ`subscribeMarketData{x set `qctpmd 2:(x;y);}' 1 1 1 2 1;  /加载
CTPMDKey:`TradingDay`InstrumentID`ExchangeID`ExchangeInstID`LastPrice`PreSettlementPrice`PreClosePrice`PreOpenInterest`OpenPrice`HighestPrice`LowestPrice`Volume`Turnover`OpenInterest`ClosePrice`SettlementPrice`UpperLimitPrice`LowerLimitPrice`PreDelta`CurrDelta`UpdateTime`UpdateMillisec`BidPrice1`BidVolume1`AskPrice1`AskVolume1`BidPrice2`BidVolume2`AskPrice2`AskVolume2`BidPrice3`BidVolume3`AskPrice3`AskVolume3`BidPrice4`BidVolume4`AskPrice4`AskVolume4`BidPrice5`BidVolume5`AskPrice5`AskVolume5`AveragePrice;
ctpmdlogined:0b;
ctpqconn:{[x;y]CTPCtrl[`Run]:initctpq[ qctpmdinfo[`front`front2`broker`user`pwd],.ctpmd.flow,(::)];};  
ctpqdisc:{[x;y]CTPCtrl[`Run]:freectpq[];upd[`FrontDisconnectQ][];};   /断开连接
ctpqlogin:{[]if[(not 1b~CTPCtrl`ConnectQ)|(1b~CTPCtrl`LoginQ);:()];ctpcall[`userLoginQ;qctpmdinfo[`broker`user`pwd]];};
ctpmdsub:{$[-11h=type x;subscribeMarketData[ctpsym2exsym x];11h=type x;subscribeMarketData[`$"," sv string ctpsym2exsym each x];:`syms_error];}; /订阅行情
upd[`taq1]:{ctpmdsub x`symlist;};
seq:0i;newseq:{seq::seq+1;:`int$seq;};
ctpcall:{[x;y]k:newseq[];C,:enlist (.z.T;k;x;y);(value x)[k;y,$[0h=type y;();enlist (::)]];};  /调用各种api接口方法
onctpmd:{[x]{upd[x[0]][x[1]];}each x;};  // 事件分发器   onctpmd:{[x]L,:(enlist .z.T),x;upd[x[0]][x[1]];};     //onctp:{[x]L,:(enlist .z.T),/:x;{UPD[x[0]][x[1]]} each x;};
upd[`FrontConnectQ]:{[x]showmsg(`OnFrontConnected);showmsg(`ReqUserLogin;qctpmdinfo[`broker`user]);CTPCtrl[`ConnectQ`ConntimeQ]:(1b;.z.P);ctpqlogin[];}; //zzz 前置机连接事件
upd[`FrontDisconnectQ]:{[x]showmsg(`OnFrontDisconnected);CTPCtrl[`ConnectQ`LoginQ`DiscReasonQ`DisctimeQ]:(0b;0b;x[0];.z.P);};  //断开连接事件
upd[`UserLoginQ]:{[x]showmsg(`OnRspUserLogin);showmsg(`SubscribingMarketData;.ctpmd.sub_syms);y:x[2];if[0=count y;:()];CTPCtrl[`LoginQ`LoginTimeQ`FrontID_Q`QSessionID_Q`QMaxOrderRef_Q]:(1b;.z.P),y;ctpmdlogined::1b; ctpmdsub[.ctpmd.sub_syms];}; //用户已登录事件函数
upd[`UserLogoutQ]:{ctpmdlogined::0b;};
upd[`SubMarketDataQ]:{showmsg[`$"SubMarketData OK."];};

upd[`DepthMD]:{[x]y:CTPMDKey!x;upd[`ctptaq](mysym:ctpexsym2sym[`$y`InstrumentID];mydate:.z.D^"D"$y[`TradingDay];.z.N^`timespan$("T"$y[`UpdateTime])+y[`UpdateMillisec];"f"$y[`PreClosePrice];"f"$y[`OpenPrice];"f"$y[`HighestPrice];"f"$y[`LowestPrice];"f"$y[`LastPrice];"f"$y[`Volume];"f"$y[`Turnover];"f"$y[`OpenInterest];0f^"f"$y[`BidPrice1];"f"$y[`BidVolume1];0f^"f"$y[`AskPrice1];"f"$y[`AskVolume1];"f"$y[`UpperLimitPrice];"f"$y[`LowerLimitPrice]);};  //行情事件函数
upd[`ctptaq]:{d:`sym`date`time`prevclose`open`high`low`close`volume`amount`openint`bid`bsize`ask`asize`upperlimit`lowerlimit!x;
  if[(d[`close]<=0f)|d[`close]=0wf;d[`close]:0f];if[(d[`open]<=0f)|d[`open]=0wf;d[`open]:d[`close]];
  if[(d[`high]<=0f)|d[`high]=0wf;d[`high]:d[`close]];if[(d[`low]<=0f)|d[`low]=0wf;d[`low]:d[`close]];if[d[`volume]=0nf;d[`volume]:0f];
  `cftaq upsert d; h(`.u.upd;`cftaq;d[`time`sym`prevclose`open`high`low`close`volume`amount`openint`bid`bsize`ask`asize`upperlimit`lowerlimit]); / 发给tp的taq必须是list不是dict
  };    
start:{showmsg`start...;getcfsyms[];ctpmdstarted::1b;ctpqconn[`;.z.P];};  //启动   start[];
stop: {showmsg`stop...;ctpmdstarted::0b;ctpqdisc[`;.z.P];};  //停止   stop[]

showmsg(`$"start within 08:50 15:00 or 20:50 23:30,stop within 15:10 15:15 or 02:40 02:45. start[]/stop[]:start/stop now.");
ctpmdstarted:0b; 
.z.ts:{ 
   if[(mod[.z.D;7]>1)&(not ctpmdstarted) & ( (.z.T within 08:50 15:00) | (.z.T within 20:50 23:30));start[]];
   if[ctpmdstarted&((.z.T within 15:10 15:15)|(.z.T within 02:40 02:45));stop[]];
   };    
\t 2000

