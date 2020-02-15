/
src: https://github.com/jlucid/qbitcoind

Copyright (c) 2017 Jeremy Lucid

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
\


\d .bitcoind


///////////////////////////////////////////////////////////
//  SECTION CONTAINING SETUP LOGIC PRIOR TO LISTED APIs
//    - Set username and password
//    - Change hostname
//    - Function to parse function input
//    - Function to perform post requests
//////////////////////////////////////////////////////////


userpassEnabled:0b
hostLookup:(enlist `bitcoind)!(enlist `$":http://127.0.0.1:8332/")
passLookup:(enlist `bitcoind)!(enlist "");


initHost:{[hostAddr]
  @[`.bitcoind;`hostLookup;,;(!) . enlist@'(`bitcoind;hsym `$hostAddr)];
 }


initPass:{[username;password]
  hostPass:":" sv (username;password);
  @[`.bitcoind;`passLookup;,;(!) . enlist@'(`bitcoind;hostPass)];
  @[`.bitcoind;`userpassEnabled;:;1b];
 }


defaultPayload:{
  (!) . (`jsonrpc`id`method`params;("1.0";0;"";()))
 }


parseArgs:{[args;requiredArgs;optionalArgs]
  if[(::)~first args;args:()];
  if[(0~count requiredArgs) & (0~count optionalArgs) & (0<count args);-1"parseArgs: No required arguments for this function";:`error];
  if[not (a:count args) in (0;($[count optionalArgs;1;0]))+c:(count requiredArgs);-1"parseArgs: There are too ",$[a<min c;"few";"many"]," arguments";:`error];
  requiredInput:$[`~requiredArgs;();(!) . (count requiredArgs)#'(requiredArgs;args)];
  if[((count args)>(count requiredArgs)) & not 99h~type last args;-1"parseArgs: Optional arguments must be passed as a dictionary";:`error];
  optionalInput:$[(count args)>(count requiredArgs);last args;()];
  requiredInput,optionalInput
 }


base64Encode:{[String]
  if[not count String;:""];
  remainder:count[String]mod 3;
  pc:count p:(0x;0x0000;0x00)remainder;
  b:.Q.b6 2 sv/: 6 cut raze 0b vs/: String,p;
  first 76 cut(neg[pc] _ b),pc#"="
 }


request:{[body]
  hostName:hostLookup[`bitcoind];
  credentials:base64Encode passLookup[`bitcoind];
  header:"text/plain \r\n","Authorization: Basic ",credentials;
  out:@[.Q.hp[hostName;header;];.j.j body;{[err] -2 "Error: request: ",err;:.j.j (enlist `error)!(enlist err)}];
  @[.j.k;;{[out;err] -2 "Error: ",err," .Q.hp returned: ",out;:(enlist `error)!(enlist out)}[out;]] out
 }


/////////////////////////////////////////////////
//         HTTP JSON_RPC CALLS
/////////////////////////////////////////////////

abandontransaction:('[{[args]
  requiredArgs:`txid;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"abandontransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


abortrescan:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"abortrescan";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


addmultisigaddress:('[{[args]
  requiredArgs:`nrequired`keys;
  optionalArgs:`label`address_type;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"addmultisigaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


addnode:('[{[args]
  requiredArgs:`node`command;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"addnode";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


backupwallet:('[{[args]
  requiredArgs:`destination;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"backupwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


bumpfee:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`options;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"bumpfee";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


clearbanned:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"clearbanned";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


createmultisig:('[{[args]
  requiredArgs:`nrequired`keys;
  optionalArgs:`address_type;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"createmultisig";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


createrawtransaction:('[{[args]
  requiredArgs:`inputs`outputs;
  optionalArgs:`locktime`replaceable;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"createrawtransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


createwallet:('[{[args]
  requiredArgs:`wallet_name;
  optionalArgs:`disable_private_keys`blank;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"createwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


decoderawtransaction:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:`iswitness;   
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"decoderawtransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


decodescript:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"decodescript";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


deriveaddresses:('[{[args]
  requiredArgs:`descriptor;
  optionalArgs:`range;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"deriveaddresses";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


disconnectnode:('[{[args]
  requiredArgs:();
  optionalArgs:`address`nodeid;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"disconnectnode";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


dumpprivkey:('[{[args]
  requiredArgs:`address;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"dumpprivkey";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


dumpwallet:('[{[args]
  requiredArgs:`filename;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"dumpwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


encryptwallet:('[{[args]
  requiredArgs:`passphrase;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"encryptwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


estimatesmartfee:('[{[args]
  requiredArgs:`conf_target;
  optionalArgs:`estimate_mode;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"estimatesmartfee";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


fundrawtransaction:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:`options`iswitness;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"fundrawtransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


generatetoaddress:('[{[args]
  requiredArgs:`nblocks`address;
  optionalArgs:`maxtries;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"generatetoaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getaddednodeinfo:('[{[args]
  requiredArgs:`node;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getaddednodeinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getaddressesbylabel:('[{[args]
  requiredArgs:`label;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getaddressesbylabel";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getaddressinfo:('[{[args]
  requiredArgs:`address;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getaddressinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getbalance:('[{[args]
  requiredArgs:();
  optionalArgs:`dummy`minconf`include_watchonly;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getbalance";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getbestblockhash:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getbestblockhash";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblock:('[{[args]
  requiredArgs:`blockhash;
  optionalArgs:`verbosity;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblock";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblockchaininfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblockchaininfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblockcount:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblockcount";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblockhash:('[{[args]
  requiredArgs:`height;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblockhash";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblockheader:('[{[args]
  requiredArgs:`blockhash;
  optionalArgs:`verbose;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblockheader";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getblocktemplate:('[{[args]
  requiredArgs:`template_request;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getblocktemplate";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getchaintips:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getchaintips";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getchaintxstats:('[{[args]
  requiredArgs:();
  optionalArgs:`nblocks`blockhash;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getchaintxstats";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getconnectioncount:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getconnectioncount";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getdescriptorinfo:('[{[args]
  requiredArgs:`descriptor;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getdescriptorinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getdifficulty:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getdifficulty";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmemoryinfo:('[{[args]
  requiredArgs:();
  optionalArgs:`mode;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmemoryinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmempoolancestors:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`verbose;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmempoolancestors";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmempooldescendants:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`verbose;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmempooldescendants";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmempoolentry:('[{[args]
  requiredArgs:`txid;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmempoolentry";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmempoolinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmempoolinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getmininginfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getmininginfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getnettotals:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getnettotals";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getnetworkhashps:('[{[args]
  requiredArgs:();
  optionalArgs:`nblocks`height;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getnetworkhashps";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getnetworkinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getnetworkinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getnewaddress:('[{[args]
  requiredArgs:();
  optionalArgs:`label`address_type;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getnewaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getnodeaddresses:('[{[args]
  requiredArgs:();
  optionalArgs:`count;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getnodeaddresses";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getpeerinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getpeerinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getrawchangeaddress:('[{[args]
  requiredArgs:();
  optionalArgs:`address_type;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getrawchangeaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getrawmempool:('[{[args]
  requiredArgs:();
  optionalArgs:`verbose;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getrawmempool";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getrawtransaction:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`verbose`blockhash;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getrawtransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


batch_getrawtransactions:('[{[args]
  supportedArgs:`txids`verbose;
  optionalArgs:`verbose;
  if[(count supportedArgs)<count args;-1"Too Many input arguments";:()];
  input:(!) . (numInputs:count args)#'(supportedArgs;args);
  body:{[tx;version;verbose]
    body:.bitcoind.defaultPayload[];
    body[`id]:version;body[`method]:"getrawtransaction";
    body[`params]:`txid`verbose!(tx;verbose);
    body
  }'[input[`txids];til count input[`txids];(count input[`txids])#$[`verbose in key input;input[`verbose];0b]];
  .bitcoind.request[body]
  };enlist]
 )


getreceivedbyaddress:('[{[args]
  requiredArgs:`address`minconf;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getreceivedbyaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getreceivedbylabel:('[{[args]
  requiredArgs:`label;
  optionalArgs:`minconf;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getreceivedbylabel";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getrpcinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getrpcinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


gettransaction:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`include_watchonly;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"gettransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


gettxout:('[{[args]
  requiredArgs:`txid`n;
  optionalArgs:`include_mempool;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"gettxout";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


gettxoutproof:('[{[args]
  requiredArgs:`txids;
  optionalArgs:`blockhash;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"gettxoutproof";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


gettxoutsetinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"gettxoutsetinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getunconfirmedbalance:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getunconfirmedbalance";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getwalletinfo:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getwalletinfo";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


getzmqnotifications:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"getzmqnotifications";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


help:('[{[args]
  requiredArgs:();
  optionalArgs:`command;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"help";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


importaddress:('[{[args]
  requiredArgs:`address;
  optionalArgs:`label`rescan`p2sh;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"importaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


importmulti:('[{[args]
  requiredArgs:`requests;
  optionalArgs:`options;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"importmulti";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


importpubkey:('[{[args]
  requiredArgs:`pubkey;
  optionalArgs:`label`rescan;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"importpubkey";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


importprivkey:('[{[args]
  requiredArgs:`privkey;
  optionalArgs:`label`rescan;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"importprivkey";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


importwallet:('[{[args]
  requiredArgs:`filename;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"importwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listaddressgroupings:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listaddressgroupings";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listbanned:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listbanned";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listlabels:('[{[args]
  requiredArgs:();
  optionalArgs:`purpose;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listlabels";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listlockunspent:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listlockunspent";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listreceivedbyaddress:('[{[args]
  requiredArgs:();
  optionalArgs:`minconf`include_empty`include_watchonly`address_filter;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listreceivedbyaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listreceivedbylabel:('[{[args]
  requiredArgs:();
  optionalArgs:`minconf`include_empty`include_watchonly;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listreceivedbylabel";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listsinceblock:('[{[args]
  requiredArgs:();
  optionalArgs:`blockhash`target_confirmations`include_watchonly`include_removed;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listsinceblock";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listtransactions:('[{[args]
  requiredArgs:();
  optionalArgs:`label`count`skip`include_watchonly;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listtransactions";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listunspent:('[{[args]
  requiredArgs:();
  optionalArgs:`minconf`maxconf`addresses`include_unsafe`query_options;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listunspent";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listwallets:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listwallets";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


listwalletdir:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"listwalletdir";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


lockunspent:('[{[args]
  requiredArgs:`unlock;
  optionalArgs:`transactions;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"lockunspent";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


ping:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"ping";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


preciousblock:('[{[args]
  requiredArgs:`blockhash;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"preciousblock";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


prioritisetransaction:('[{[args]
  requiredArgs:`txid;
  optionalArgs:`dummy`fee_delta;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"prioritisetransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


pruneblockchain:('[{[args]
  requiredArgs:`height;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"pruneblockchain";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


removeprunedfunds:('[{[args]
  requiredArgs:`txid;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"removeprunedfunds";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


rescanblockchain:('[{[args]
  requiredArgs:();
  optionalArgs:`start_height`stop_height;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"rescanblockchain";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


savemempool:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"savemempool";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


scantxoutset:('[{[args]
  requiredArgs:`action`scanobjects;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"scantxoutset";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


sendrawtransaction:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:`allowhighfees;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"sendrawtransaction";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


sendmany:('[{[args]
  requiredArgs:`dummy`amounts;
  optionalArgs:`minconf`comment`subtractfeefrom`replaceable`conf_target`estimate_mode;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"sendmany";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


sendtoaddress:('[{[args]
  requiredArgs:`address`amount;
  optionalArgs:`comment`comment_to`subtractfeefromamount`replaceable`conf_target`estimate_mode;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"sendtoaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


setban:('[{[args]
  requiredArgs:`subnet`command;
  optionalArgs:`bantime`absolute;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"setban";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


setlabel:('[{[args]
  requiredArgs:`address`label;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"setlabel";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


setnetworkactive:('[{[args]
  requiredArgs:`state;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"setnetworkactive";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


settxfee:('[{[args]
  requiredArgs:`amount;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"settxfee";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


signmessage:('[{[args]
  requiredArgs:`address`message;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"signmessage";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


signmessagewithprivkey:('[{[args]
  requiredArgs:`privkey`message;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"signmessagewithprivkey";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


signrawtransactionwithkey:('[{[args]
  requiredArgs:`hexstring`privkeys;
  optionalArgs:`prevtxs`sighashtype;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"signrawtransactionwithkey";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


signrawtransactionwithwallet:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:`prevtxs`sighashtype;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"signrawtransactionwithwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


stop:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"stop";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


submitblock:('[{[args]
  requiredArgs:`hexdata;
  optionalArgs:`dummy;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"submitblock";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


testmempoolaccept:('[{[args]
  requiredArgs:`rawtxs;
  optionalArgs:`allowhighfees;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"testmempoolaccept";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


walletlock:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"walletlock";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


walletpassphrase:('[{[args]
  requiredArgs:`passphrase`timeout;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"walletpassphrase";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


walletpassphrasechange:('[{[args]
  requiredArgs:`oldpassphrase`newpassphrase;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"walletpassphrasechange";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


unloadwallet:('[{[args]
  requiredArgs:();
  optionalArgs:`wallet_name;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"unloadwallet";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


uptime:('[{[args]
  requiredArgs:();
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"uptime";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


validateaddress:('[{[args]
  requiredArgs:`address;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"validateaddress";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


verifychain:('[{[args]
  requiredArgs:();
  optionalArgs:`checklevel`nblocks;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"verifychain";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


verifytxoutproof:('[{[args]
  requiredArgs:`proof;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"verifytxoutproof";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


verifymessage:('[{[args]
  requiredArgs:`address`signature`message;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"verifymessage";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


// BIP 174 Partially Signed Bitcoin Transactions support


joinpsbts:('[{[args]
  requiredArgs:`txs;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"joinpsbts";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


analyzepsbt:('[{[args]
  requiredArgs:`psbt;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"analyzepsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


converttopsbt:('[{[args]
  requiredArgs:`hexstring;
  optionalArgs:`permitsigdata`iswitness;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"converttopsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


createpsbt:('[{[args]
  requiredArgs:`inputs`outputs;
  optionalArgs:`locktime`replaceable;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"createpsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


walletcreatefundedpsbt:('[{[args]
  requiredArgs:`inputs`outputs;
  optionalArgs:`locktime`options`bip32derivs;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"walletcreatefundedpsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


walletprocesspsbt:('[{[args]
  requiredArgs:`psbt;
  optionalArgs:`sign`sighashtype`bip32derivs;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"walletprocesspsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


finalizepsbt:('[{[args]
  requiredArgs:`psbt;
  optionalArgs:`extract;
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"finalizepsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


combinepsbt:('[{[args]
  requiredArgs:`txs;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"combinepsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


decodepsbt:('[{[args]
  requiredArgs:`psbt;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"decodepsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


utxoupdatepsbt:('[{[args]
  requiredArgs:`psbt;
  optionalArgs:();
  input:parseArgs[args;requiredArgs;optionalArgs];
  if[`error~input;:()];
  body:.bitcoind.defaultPayload[];
  body[`method]:"utxoupdatepsbt";
  body[`params]:input;
  .bitcoind.request[body]
  };enlist]
 )


\d .
