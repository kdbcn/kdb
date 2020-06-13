//=========web数据读取函数=========
/代码格式转换：`0xxxxxx => `xxxxxx.SH, `1xxxxxx=>`xxxxxx.SZ : necode2sym[`0600036]   necode2sym[`1000001]
necode2sym:{`$$["0"~first sx:string x;(1_sx),".SH";"1"~first sx;(1_sx),".SZ";sx]};   
/代码格式转换：`xxxxxx.SH => `0xxxxxx, `xxxxxx.SZ => `1xxxxxx :  sym2necode[`000001.SH]   sym2necode[`000001.SZ]
sym2necode:{`$$[".SH"~-3#sx:string x;"0",-3_sx;".SZ"~-3#sx;"1",-3_sx;sx]}; 

/读交易日(上证综指日线数据日期）: gettrddt[.z.D-7;.z.D]
gettrddt:{[startdate;enddate]`date xasc `date xcol("D   ";enlist",")0:.Q.hg "http://quotes.money.163.com/service/chddata.html?code=0000001&start=",ssr[string[startdate];".";""],"&end=",ssr[string enddate;".";""],"&fields=TCLOSE"};

/读A股代码表 getcsasyms[]
getcsasyms:{select sym:necode2sym each code,`$name from update `$code from {lower[cols x]xcol x}.j.k[.Q.hg "http://quotes.money.163.com/hs/service/diyrank.php?query=STYPE%3AEQA&fields=CODE,NAME&sort=SYMBOL&order=asc&count=8000&type=query"]`list};

/读指数代码表 getcsisyms[] or getcsisyms[`SH] or getcsisyms[`SZ]
getcsisyms:{ /ex: getcsisyms[] or getcsisyms[`SH] or getcsisyms[`SZ]
 qrystr:$[null x;qs:"CODE:_in_0000001,0000016,0000300,0000905,0000906,0000852,1399001,1399005,1399006,1399106";x=`SH;"IS_INDEX:true;EXCHANGE:CNSESH";x=`SZ;"IS_INDEX:true;EXCHANGE:CNSESZ";qs]; select sym:necode2sym each`$code,`$name from {lower[cols x]xcol x}.j.k[.Q.hg"http://quotes.money.163.com/hs/service/hsindexrank.php?host=/hs/service/hsindexrank.php&page=0&query=",qrystr,"&fields=no,SYMBOL,NAME&sort=SYMBOL&order=asc&count=5000&type=query"]`list};

/读A股、指数的日行情:  getcsbar[`000001.SH;.z.D-3;.z.D]
getcsbar:{[mysym;startdate;enddate]`date xasc update sym:mysym,open:?[open>0;open;prevclose],high:?[high>0;high;prevclose],low:?[low>0;low;prevclose],close:?[close>0;close;prevclose],0f^mv,0f^fmv from `date`sym`prevclose`open`high`low`close`volume`amount`mv`fmv xcol("DS FFFFFFFFF";enlist",")0: .Q.hg "http://quotes.money.163.com/service/chddata.html?code=",string[sym2necode mysym],"&start=",ssr[string[startdate];".";""],"&end=",ssr[string enddate;".";""],"&fields=LCLOSE;TOPEN;HIGH;LOW;TCLOSE;VOTURNOVER;VATURNOVER;TCAP;MCAP"};

/读A股最新行情: prevclose昨收价,open开盘价,high最高价,low最低价,close最新价,volume成交量,amount成交金额,mv总市值,fmv流通市值,eps每股收益,zdf涨跌幅,zf震幅,hsl换手率,pe市盈率
getcsataq:{  /ex: getcsataq[] or getcsataq `000001.SZ or getcsataq `600036.SH
 qrystr:$[null x;"STYPE%3AEQA";-11h=type[x];"CODE%3A",string[sym2necode x],"%3BSTYPE%3AEQA";"STYPE%3AEQA"]; : select dt:"Z"$time,sym:necode2sym each`$code,`$name,prevclose:yestclose,open:?[open>0;open;yestclose],high:?[high>0;high;yestclose],low:?[low>0;low;yestclose],close:?[price>0;price;yestclose],volume,amount:turnover,mv:tcap,fmv:mcap,eps:mfsum,zdf:percent,zf,hsl:hs,pe from {lower[cols x]xcol x} {key[d]#d:(`CODE`HIGH`HS`LOW`MCAP`MFSUM`NAME`OPEN`PE`PERCENT`PRICE`SYMBOL`TCAP`TIME`TURNOVER`VOLUME`YESTCLOSE`ZF`NO!(();0Nf;0Nf;0Nf;0Nf;0Nf;();0Nf;0Nf;0Nf;0Nf;();0Nf;();0Nf;0Nf;0Nf;0Nf;0Nf)),x} each {(.j.k[x])`list} .Q.hg"http://quotes.money.163.com/hs/service/diyrank.php?page=0&query=",qrystr,"&fields=NO%2CSYMBOL%2CNAME%2CYESTCLOSE%2CPRICE%2CPERCENT%2COPEN%2CHIGH%2CLOW%2CVOLUME%2CTURNOVER%2CHS%2CZF%2CPE%2CMFSUM%2CMCAP%2CTCAP%2CCODE%2CTIME&sort=PERCENT&order=desc&count=8000&type=query"};

/读指数最新行情:  
getcsitaq:{ /ex: getcsitaq[] or getcsitaq[`000001.SH] or getcsitaq[`399001.SZ]
 qrystr:$[null x;qs:"CODE:_in_0000001,0000016,0000300,0000905,0000906,0000852,1399001,1399005,1399006,1399106";-11h=type[x];"CODE:_in_",string[sym2necode x];qs]; select dt:"Z"$time,sym:necode2sym each`$code,name,prevclose:yestclose,open,high,low,close:price,volume,amount:turnover,mv:0f,fmv:0f,eps:0f,zdf:percent,zf:zhenfu,hsl:0f,pe:0f from {lower[cols x]xcol x}.j.k[.Q.hg"http://quotes.money.163.com/hs/service/hsindexrank.php?host=/hs/service/hsindexrank.php&page=0&query=",qrystr,"&fields=no,TIME,SYMBOL,NAME,PRICE,UPDOWN,PERCENT,zhenfu,VOLUME,TURNOVER,YESTCLOSE,OPEN,HIGH,LOW&sort=SYMBOL&order=asc&count=25&type=query"]`list};

/中金所行情
getcfebar:{[mydate]if[-14h<>type mydate;:`error_para];et:flip`date`sym`open`high`low`close`volume`amount`openint!"DSFFFFFFF"$\:();
  if[mydate<2010.04.16;:et];datestr:string[mydate]_/ 4 6;monthstr:6#datestr;daystr:-2#datestr;
 `date xcols update date:mydate from{update {`$string[x],".CFE"}each sym,0f^open,0f^high,0f^low,0f^close,amount*10000.0 from select from x where sym like "*[0-9]"}
 `sym`open`high`low`close xcols`sym`open`high`low`volume`amount`openint`close xcol("S",7#"F";enlist",")0: 
 .Q.hg"http://www.cffex.com.cn/sj/hqsj/rtj/",monthstr,"/",daystr,"/",datestr,"_1.csv"};

/上期所行情
getshfbar:{[mydate]if[-14h<>type mydate;:`error_para];et:flip`date`sym`open`high`low`close`volume`amount`openint!"DSFFFFFFF"$\:();
  r:@[.j.k;ssr[;":\"\",";":0,"].Q.hg"http://www.shfe.com.cn/data/dailydata/kx/kx",(string[mydate]_/4 6),".dat";`];
  :$[99h=type r;
  {select from x where sym like "*[0-9].SHF"}select date:mydate,sym:(`$(upper -2_/:trim PRODUCTID),'DELIVERYMONTH,\:".SHF"),open:OPENPRICE,high:HIGHESTPRICE,low:LOWESTPRICE,close:CLOSEPRICE,volume:VOLUME,amount:0f,openint:OPENINTEREST from select from r[`o_curinstrument] where (10h=type each DELIVERYMONTH)&10h=type each PRODUCTID;
  et];
  };
  
/上期能源行情
getinebar:{[mydate]if[-14h<>type mydate;:`error_para];et:flip`date`sym`open`high`low`close`volume`amount`openint!"DSFFFFFFF"$\:();
  if[mydate<2018.03.26;:et];
  r:@[.j.k;ssr[;":\"\",";":0,"] .Q.hg"http://www.ine.cn/data/dailydata/kx/kx",(string[mydate]_/4 6),".dat";`];
  :$[99h=type r;
  {select from x where sym like "*[0-9].INE"}select date:mydate,sym:(`$(upper -2_/:trim PRODUCTID),'DELIVERYMONTH,\:".INE"),open:OPENPRICE,high:HIGHESTPRICE,low:LOWESTPRICE,close:CLOSEPRICE,volume:VOLUME,amount:0f,openint:OPENINTEREST from select from r[`o_curinstrument] where (10h=type each DELIVERYMONTH)&10h=type each PRODUCTID;
  et];
  };  
  
  /大商所品种
getdceprod:{[mydate]dstr:string[mydate]_/4 6;mstr:string neg[1]+`mm$mydate;
  distinct update{upper `$ssr[string x;"[0-9]";""]}each sym from{select from x where sym like "*[0-9]"}`name`sym xcol
  ("SS ";enlist"\t")0: ssr[;"%";""]ssr[;"\t\t";"\t"]
 .Q.hp["http://www.dce.com.cn/publicweb/businessguidelines/exportFutAndOptSettle.html";"application/x-www-form-urlencoded"]
       "variety=all&trade_type=0&year=",(4#dstr),"&month=",mstr,"&day=",(-2#dstr),"&exportFlag=txt"};
/ 大商所行情
getdcebar:{[mydate]if[-14h<>type mydate;:`error_para];
	dceprod:`name xkey getdceprod[mydate]; /大商所品种及其名称
    r:.Q.hg"http://www.dce.com.cn/publicweb/quotesdata/exportDayQuotesChData.html?dayQuotes.variety=all&dayQuotes.trade_type=0&year=",string[`year$mydate],"&month=",string[neg[1]+`mm$mydate],"&day=",string[`dd$mydate],"&exportFlag=txt";
    select date:mydate,sym:sym{`$string[x],string[y],".DCE"}'month,open,high,low,close,volume,amount*10000f,openint from 
    lj[;dceprod]{select from x where month>0}`name`month`open`high`low`close`volume`openint`amount xcol    ("SJFFFF    FF F";enlist"\t")0: ssr[ssr[r;",";""];"\t\t";"\t"] };
	
/郑商所行情
czchttp:{[path] r:`:http://www.czce.com.cn "GET ",path," HTTP/1.1\r\nHost: www.czce.com.cn\r\nAccept-Encoding: identity",$[`Cookie in key `.czce;"\r\n",.czce.Cookie;""],"\r\n\r\n";
     if[not()~ck:{x where x like "Set-Cookie:*"}"\r\n" vs first["\r\n\r\n" vs r];
     r:`:http://www.czce.com.cn "GET ",path," HTTP/1.1\r\nHost: www.czce.com.cn\r\nAccept-Encoding: identity\r\n",(.czce.Cookie::4_first ck),"\r\n\r\n"];
    :(vs[" ";first "\r\n" vs first["\r\n\r\n" vs r]][1];  (first[ss[r;"\r\n\r\n"]]+4)_r);  /(status;body)
 };
getczcbar:{[mydate]if[-14h<>type mydate;:`error_para];dstr:string[mydate]_/4 6; et:flip`date`sym`open`high`low`close`volume`amount`openint!"DSFFFFFFF"$\:();
 :`date xcols update date:mydate from{[mydate;x]select {[d;s]s:string[s];i:0;while[(i<9)&(`month$d)>"M"$"20",yymm:string[i],(-3#s);i+:1];`$(-3_s),yymm,".CZC"}[mydate]each sym,open,high,low,close,volume,amount*10000f,openint from x where sym like "*[0-9]"}[mydate]
 $[mydate>2015.09.18;
	[r:czchttp["/cn/DFSStaticFiles/Future/",(4#dstr),"/",dstr,"/FutureDataDaily.txt"];
		$[r[0]~"200";`sym`open`high`low`close`volume`openint`amount xcol("S FFFF   FF F";enlist"|")0:ssr[r 1;",";""];:et]
	];
  mydate>=2010.08.25;
	[r:czchttp["http://www.czce.com.cn/cn/exchange/",(4#dstr),"/datadaily/",dstr,".txt"];
		$[r[0]~"200";`sym`open`high`low`close`volume`openint`amount xcol("S FFFF   FF F";enlist",")0:r 1;:et]
	];
	[r:czchttp["/cn/exchange/jyxx/hq/hq",dstr,".html"];  
		$[r[0]~"200";flip`sym`open`high`low`close`volume`openint`amount!("S FFFF  FF F  ";",")0: 
		enlist  ssr[;" ";""]ssr[;"</td>\r\n";","]ssr[;",";""]ssr[;"\r\n</tr>\r\n<tr>";"\r\n"]ssr[;"<td class=tdformat align=right>";""] ssr[;"<td class=lefttdformat align=left>";""]  
		{last[ss[x;"</tr>\r\n<table>\r\n</td></tr></table>"]]#x} {(first[ss[x;"<td class=lefttdformat align=left>"]])_x} r 1;:et]
	]
  ];
 };


/期货当前合约
gethxcfsyms:{[ex] /ex: gethxcfsyms`CFE   gethxcfsyms`SHF   gethxcfsyms`DCE   gethxcfsyms`CZC
 :`sym xasc select sym:(`$sym,\:".",string[ex]) from flip `sym`id!flip last last .j.k 1_-2_ 
 .Q.hg $[ex=`CFE;"http://webcffex.hermes.hexun.com/cffex/sortlist?block=770";
       "http://webftcn.hermes.hexun.com/gb/shf/sortlist?block=",$[ex=`SHF;"430";ex=`DCE;"431";"432"]
        ],"&number=1000&title=15&commodityid=0&direction=0&start=0&column=code" ;
 };

/行情数据
gethxbar:{[mysym;startdate;num;bartype]  /"num:x or -x,x<=1000;  bartype:`1m`5m`30m`60m`1d`1w`1m"
 sym2hxsym:{$[x like "*.SH";"sse",-3_string[x];x like "*.SZ";"szse",-3_string[x];x like "*.CFE";"CFFEX",-4_string[x];like[x;"[FR]U*.SHF"] or like[x;"WR*.SHF"] or like[x;"HC*.SHF"] or like[x;"RB*.SHF"] or like[x;"SP*.SHF"];"SHFE",-4_string[x];x like "A[GU]*.SHF";"SHFE2",-4_string[x];x like "*.SHF";"SHFE3",-4_string[x];x like "*.DCE";"DCE",-4_string[x];x like "*.CZC";"CZCE",-4_string[x];string[x]]};
 r:.j.k -2_1_ .Q.hg URL::$[mysym like "*.S[HZ]";"http://webstock.quote.hermes.hexun.com/a";mysym like "*.CFE";"http://webcffex.hermes.hexun.com/cffex";"http://webftcn.hermes.hexun.com/shf"],"/kline?code=",sym2hxsym[mysym],"&start=",(string[startdate]_/4 6),"000000&number=",string[num],"&type=",(`1m`5m`15m`30m`60m`1d`1w`1m`!"012345675")[bartype];
 rrr:flip lower[raze key each r`Kline]!flip(rr:r`Data)[0];
 :$[mysym like "*.S[HZ]";select date:"D"$8#/:string[`long$time],sym:mysym,time:`timespan$"T"$-6#/:string[`long$time],prevclose:lastclose%rr[4],open%rr[4],high%rr[4],low%rr[4],close%rr[4],volume,amount,openint:0f from rrr;
    select date:"D"$8#/:string[`long$time],sym:mysym,time:`timespan$"T"$-6#/:string[`long$time],prevclose:lastclose%rr[4],open%rr[4],high%rr[4],low%rr[4],close%rr[4],volume,amount,openint:openinterest from rrr];
 };
 
/下载数据并以分列表形式保存在hdb :  setcsbar[]
setcsbar:{0N!(.z.T;`start...);
    hdbpath:hsym `$hdbp:ssr[getenv`QHOME;"\\";"/"],"/../hdb"; /hdb路径，如果没有定义QHOME需要修改
	@[.Q.chk;hdbpath;`];@[system;"l ",hdbp;`];
	newdatelist:exec date from gettrddt[;.z.D] 1+$[`csbar in key `.;2010.01.01^exec last date from select max date from csbar;2010.01.01];
    if[0=count newdatelist;:`no.upd.required];
	dt:exec first dt from getcsitaq[`000001.SH];
	if[(1=count[newdatelist])&(last[newdatelist]=`date$dt)&(15:01:00<`time$dt);
		t:select date:`date$dt,sym,prevclose,open,high,low,close,volume,amount,mv,fmv from getcsataq[],getcsitaq[];
		if[(98h=type t)&(0<count t);(` sv (hdbpath;`csbar;`) ) upsert .Q.en[hdbpath] `sym xasc t;0N!(.z.T;`date$dt;`updated.)];
		0N!(.z.T;`stop.);
		:()];
	{[mysym;firstdate;lastdate;hdbpath]0N!(.z.T;mysym;firstdate;lastdate);
	   (` sv (hdbpath;`csbar;`) ) upsert .Q.en[hdbpath]select date,sym,prevclose,open,high,low,close,volume,amount,mv,fmv from getcsbar[mysym;firstdate;lastdate];
	}[;first newdatelist;last newdatelist;hdbpath]each asc distinct exec sym from getcsisyms[],getcsasyms[];
	@[` sv (hdbpath;`csbar;`);`date`sym;`g#];
	0N!(.z.T;`stop.);
 };

/将分列表csbar保存为分区表csbarp(..p=partitioned) 
setcsbarp:{[startdate;enddate]0N!(.z.T;`start...); 
    hdbpath:hsym `$hdbp:ssr[getenv`QHOME;"\\";"/"],"/../hdb"; /hdb路径，如果没有定义QHOME需要修改
	.Q.chk hdbpath;system "l ",hdbp;
	{[dt;hdbpath]0N!(.z.T;dt;hdbpath);
	 (` sv (hdbpath;`$string dt;`csbarp;`) ) set .Q.en[hdbpath]`sym xasc select sym,prevclose,open,high,low,close,volume,amount,mv,fmv from csbar where date=dt;
	 }[;hdbpath]each exec distinct date from csbar where date within (startdate;enddate);
 };

/下载期货行情数据并以分列表形式保存在hdb :  setcfbar[]
setcfbar:{0N!(.z.T;`start...);
    hdbpath:hsym `$hdbp:ssr[getenv`QHOME;"\\";"/"],"/../hdb"; /hdb路径，如果没有定义QHOME需要修改
	@[.Q.chk;hdbpath;`];@[system;"l ",hdbp;`];
	newdatelist:exec date from gettrddt[;.z.D] 1+$[`cfbar in key `.;2010.01.01^exec last date from select max date from cfbar;2010.01.01];
    if[0=count newdatelist;:`no.upd.required];
	{[dt;hdbpath]0N!(.z.T;dt;hdbpath); 
	 (` sv (hdbpath;`cfbar;`) ) upsert .Q.en[hdbpath]`sym xasc select date,sym,open,high,low,close,volume,amount,openint from 
            getcfebar[dt],getshfbar[dt],getinebar[dt],getdcebar[dt],getczcbar[dt];
	 }[;hdbpath]each newdatelist;
	@[` sv (hdbpath;`cfbar;`);`date`sym;`g#];
	0N!(.z.T;`stop.);
 };
