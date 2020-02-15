bt:{[para]:select sym,date,eq,ret,annret,mdd,trades,wins,fee:para`fee,m1:para`m1,m2:para`m2 from 
 select by sym from update ret:{-1+x%first x} eq, annret:{[x;y]((y%first y) 
        xexp' 365.0%(x-first x))-1} [date;eq],mdd:{1-mins x %maxs x}eq,trades:sums((ps=0)&0<0^prev ps),
        wins:sums (ps<prev ps)&(0<0^prev ps)&(close>prev px)  by sym from 
 {(delete pp from x),'(::)each exec pp from x} //pp dict => field
 update pp: {[x;y]if[0=x`ps;x:`ps`pt`px`ca`eq!(0j;0Np;0f;x`ca;x`eq)];  
    if[(x[`ps]>0)&(y[`ma1]<y`ma2); x[`ca]:x[`ca]+x[`ps]*y[`close]*(1-y[`fee]);
             x[`eq]:x[`ca]; x[`ps]:0 ];     
    if[(x[`ps]=0)&y[`flg]&(y[`ma1]>y`ma2);x[`pt]:y[`date]; x[`px]:y[`close];
            x[`ps]:100*floor 0.01*x[`ca] div y[`close]*(1+y[`fee]);
            x[`ca]:x[`ca]-x[`ps]*y[`close]*(1+y[`fee]) ];
    x[`eq]:x[`ca]+x[`ps]*y[`close];  :x; }  
   \ [`ps`pt`px`ca`eq!(0j;0Np;0f;10000000f;10000000f) ; 
     flip`date`close`ma1`ma2`flg`fee!(date;close;ma1;ma2;flg;para`fee)] by sym from
 update ma1:mavg[para`m1;close],ma2:mavg[para`m2;close],flg:100<i-first i by sym from
 update close:close*{x%last x}prds prev[close]%prevclose by sym from
 `sym`date xasc select sym,date,prevclose,close from csbar1d where sym like "30*.SZ";
 };
system"l d:/kdb/hdb";
bt`fee`m1`m2!(0.0004;20;100)