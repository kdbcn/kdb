 //均线策略，限制最多持有只数
 system "l d:/kdb/hdb";
 //参数：p1/p2均线参数，ca0初始资金，fee费率，dt0/dt1起止日期，max_pos_syms最多持有只数
 para:`p1`p2`ca0`fee`dt0`dt1`max_pos_syms!(5;10;10000000f;0.0004;2019.01.01;.z.D;10);
 //L04:结果
 select last n,last eq,last ret,last annret,last mdd by date from 
 update ret:{-1+x%first x}[eq],
  annret:{[x;y]((y%first y) xexp' 365.0%(x-first x))-1}[date;eq],
  mdd:{1-mins x %maxs x}eq from  
 {delete pos from (delete pp from x),'(::)each exec pp from x}
 //L03:计算交易信号、净值等
 update pp:{[x;y]
    /L03a:持仓，更新价格
    pos:x`pos;pos[y`sym;`close]:y`close;
    /L03b:计算当前持股只数
    num:0^exec count sym from pos where ps>0;
    /L03c:卖出
    if[(pos[y`sym;`ps]>0)&(y[`ma1]<y`ma2)&((y`date)>pos[y`sym;`pt]);
       x[`ca]:x[`ca]+pos[y`sym;`ps]*y[`close]*(1-para[`fee]);
       x[`eq]:x[`ca]+exec sum ps*close from pos;pos[y`sym;`ps]:0 ];
    /L03d:若无持仓，设置相关字段
    if[null[pos[y`sym;`ps]] or pos[y`sym;`ps]=0;
            pos[y`sym;`ps`pt`px`n]:(0;0Nd;0f;0)];
    /L03e:买入
    if[(pos[y`sym;`ps]=0)&y[`flg]&(y[`ma1]>y`ma2)&(num<para[`max_pos_syms]);
        pos[y`sym;`n]:num+1;pos[y`sym;`pt]:y[`date];pos[y`sym;`px]:y[`close];
        pos[y`sym;`ps]:100*floor 0.01*(x[`ca]%para[`max_pos_syms]-num) div pos[y`sym;`px];
        x[`ca]:x[`ca]- pos[y`sym;`ps]*y[`close]*(1+para[`fee])];
    /L03f:更新eq，返回
    x[`eq]:x[`ca]+exec sum ps*close from pos;
    : pos[y`sym],`pos`ca`eq!(pos;x`ca;x`eq);
 }\[`pos`ca`eq!(([sym:`$()]ps:`long$();pt:`date$();px:`float$();close:`float$();n:`long$());para[`ca0];para[`ca0]);
   flip `date`sym`close`ma1`ma2`flg!(date;sym;close;ma1;ma2;flg)] from
 //L02：计算均线
 `date xasc update ma1:mavg[para[`p1];close],ma2:mavg[para[`p2];close],flg:para[`p2]<i-first i by sym from
 //L01:复权
 update close:close*{x%last x}prds prev[close]%prevclose by sym from
 `sym`date xasc select sym,date,prevclose,close from csbar1d 
  where date within para[`dt0`dt1],sym like "300*.SZ"
