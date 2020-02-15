//动量策略：每周三买入创业板最近10日涨幅排名居前10%的股票，买入数量为净值*0.001除以ATR，直到资金用完为止
//L01:加载数据库 d:/kdb/hdb
system "l d:/kdb/hdb";
//L02:初始化ca（现金）/eq（净值/权益）变量
ca:eq:10000000f;
//L03:参数
para:`p1`rf`fee`dt0`dt1!(10;0.001;0.0004;2019.05.01;.z.D);
//L04:持仓position
pos:([sym:`$()]ps:`long$();pt:`date$();px:`float$();close:`float$());
//L05:组合portfolio
por:([date:`date$()]pos:();ca:`float$();eq:`float$());
//L06:交易日期表
dates: `date xasc select date,flg:4=date mod 7 from csbar1d 
        where sym=`000001.SH,date within para[`dt0`dt1];
//L07：生成bars
 bars:update chg:(close%xprev[para`p1;close])-1,
 atr:{[h;l;c;n]n mavg(h-l)|(abs h-prev c)|(abs l-prev c)}[high;low;close;20]by sym from 
 {[p1;x]select from x where p1<=(count;i)fby sym}[para`p1]
 update high*af,low*af,close*af from
 update af:{x%last x}prds prev[close]%prevclose by sym from
 `sym`date xasc select sym,date,prevclose,high,low,close,volume from csbar1d 
 where sym like "3000*.SZ",date within para`dt0`dt1;
 /L08:计算周三涨幅位次
 update rnk:10 xrank chg by date from  `bars 
  where date in exec date from dates where flg;
//L09:按日期循环      
//L09a: di初始化
di:0;
//L09b:开始循环
do[count dates;
  d:dates[di];  //L09c
  //L09d: 周三
  if[d[`flg] & di>para`p1;
    /L09e:取d[`date]的数据   
    bar:`rnk`chg xdesc select from bars where date=d`date;  
    /L09f:卖出
    bi:0;do[count bar;b:bar[bi];
         if[(pos[b`sym;`ps]>0)&b[`rnk]<>9;
             ca:ca+pos[b`sym;`ps]*b[`close]*1-para[`fee];
             pos[b`sym;`ps]:0];
         bi:bi+1];  
    /L09g:买入；由于买入要考虑现金是否充足，先卖后买
    bi:0;do[count bar;b:bar[bi]; 
         if[(pos[b`sym;`ps] in (0j;0Nj))&(b[`rnk]=9)&(b[`volume]>0)&(b[`atr]>0);
            bqty:100*floor 0.01*eq*para[`rf]%b`atr;
            if[(bqty>0)&(ca>myca:bqty*b[`close]*1+para`fee);
                 pos[b`sym;`ps`pt`px]:(bqty;d`date;b[`close]*1+para`fee);
                 ca:ca-myca]]; 
         bi:bi+1];  
  ];  //L09d结束
 //L09h:更新持仓表
 delete from `pos where ps=0;
 update close:{[mydate;mysym]exec 0f^last close from bars
                where date=mydate,sym=mysym}[d`date]each sym from `pos;
 //L09i: 更新组合表
 por[d[`date];`pos`ca`eq]:(pos;ca;eq:ca+{$[x~();0f;x]}exec sum ps*close from pos where ps>0);  
 //L09j: 下一交易日
 di:di+1
 ]; //L09b结束
//L10:结束，显示绩效指标，可根据需要进一步处理
select date,eq,ret:{-1+x%first x}[eq],annret:{[x;y]((y%first y) xexp' 365.0%(x-first x))-1}[date;eq],
  mdd:{1-mins x %maxs x}[eq],symcnt:{exec count i from x where ps>0}each pos from por
