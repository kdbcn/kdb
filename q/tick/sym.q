//trade & quote
cstaq:([]time:`timespan$();sym:`g#`symbol$();prevclose:`float$();open:`float$();high:`float$();low:`float$();close:`float$();volume:`float$();amount:`float$();bid:`float$();bsize:`float$();ask:`float$();asize:`float$());

//cftaq
cftaq:([]time:`timespan$();sym:`g#`symbol$();prevclose:`float$();open:`float$();high:`float$();low:`float$();close:`float$();volume:`float$();amount:`float$();openint:`float$();bid:`float$();bsize:`float$();ask:`float$();asize:`float$();upperlimit:`float$();lowerlimit:`float$());

//msg
msg:([]time:`timespan$();sym:`g#`symbol$();src:`int$();data:());