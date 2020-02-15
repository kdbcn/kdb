//L07:取出最后一行
 select sym,date,eq,ret,annret,mdd,trades,wins from select by sym from
//L06:计算绩效指标，如ret(收益率),annret(年化收益率),mdd(最大回撤),trades(交易次数)等
 update ret:{-1+x%first x} eq, annret:{[x;y]((y%first y) xexp' 365.0%(x-first x))-1} [date;eq],
        mdd:{1-mins x %maxs x}eq, trades:sums((ps=0)&0<0^prev ps),
        wins:sums (ps<prev ps)&(0<0^prev ps)&(close>prev px)  by sym from 
 //L05:将pp dict转为字段方便后续处理。   
 {(delete pp from x),'(::)each exec pp from x} //pp dict => field
 //L04:计算信号，权益等： pp:{[x;y]...}\[ x初始值;y序列数据]
 update pp: {[x;y]
    //L04a:初始化
    if[0=x`ps;x:`ps`pt`px`ca`eq!(0j;0Np;0f;x`ca;x`eq)];  
    //L04b:卖出  
    if[(x[`ps]>0)&(y[`ma1]<y`ma2);
             x[`ca]:x[`ca]+x[`ps]*y[`close]*(1-y[`fee]);
             x[`eq]:x[`ca];
             x[`ps]:0 ];     
    //L04c:买入
    if[(x[`ps]=0)&y[`flg]&(y[`ma1]>y`ma2);
            x[`pt]:y[`date]; x[`px]:y[`close];
            x[`ps]:100*floor 0.01*x[`ca] div y[`close]*(1+y[`fee]);
            x[`ca]:x[`ca]-x[`ps]*y[`close]*(1+y[`fee]) ];
   //L04d:更新eq
    x[`eq]:x[`ca]+x[`ps]*y[`close]; 
   //L04e:返回x
   :x; }  
   //L04f: ps=position,pt=date,px=price,ca=cash,eq=equity
   \ [`ps`pt`px`ca`eq!(0j;0Np;0f;10000000f;10000000f) ; flip`date`close`ma1`ma2`flg`fee!(date;close;ma1;ma2;flg;0.0004)] by sym from
 //L03:计算均线指标
 update ma1:mavg[20;close],ma2:mavg[100;close],flg:100<i-first i by sym from
 //L02:复权（向前复权）
 update close:close*{x%last x}prds prev[close]%prevclose by sym from
 //L01:读取数据并排序
 `sym`date xasc select sym,date,prevclose,close from csbar1d   where sym like "30*.SZ"
 

\

//若为期货品种，可用以下替换L02、L01的代码，对期货合约行情数据进行预处理，生成“连续合约”行情数据。

//L07：计算开、高、低、收的“复权价”，得到连续合约行情数据
update open*af,high*af,low*af,close*af from
 //L06：以股票向前复权的方式计算连续合约复权因子
 update af:{x%last x}prds prev[close]%prevclose by sym from   
 //L05:取每一品种每一天的最后一条记录，即得到每一品种最大持仓量记录
 0!select by sym,date from
 //L04: 排序
  `sym`date`prevopenint xasc 
//L03: 把原合约代码保存为mainsym，
//     把原合约代码的数字部分删除，得到品种代码（如AU.SHF），记为sym
update sym:`$ssr[;"[0-9]";""]each string sym  from update mainsym:sym from  
 //L02：取得每个合约的前一交易日的收盘价prevclose、持仓量prevopenint
 update prevclose:close^prev close,prevopenint:openint^prev openint by sym from
//L01：取数据
 `sym`date xasc select sym,date,open,high,low,close,
volume,openint from cfbar1d where date>2010.01.01

 
 
 