include "Io.dfy"
/*
method {:main} Main ()
{
  var s, chars := encode([1, 2, 3, 20, 20, 30, 200, 201, 20, 20, 1]);
  print(s);
  print(chars);
}*/

/*predicate firstElementofDataIsInTableFirtst256(data:seq<byte>, table:array<seq<byte>>)
requires data != [] && table.Length==4096
{
   forall a :: 0<=a<=255 ==> contains(data, first[a]);
}*/

method encode(data: array<byte>) returns (out: seq<byte>, table: array<seq<byte>>)
//requires data.Length > 0;
//ensures forall k :: 0 <= k < |data| ==> exists i :: 0 <= i < |table| ==> table[i] == data[k]
{
  table := new seq<byte>[8192];
  var s:seq<byte>;
  out := [];
  var j:byte:=0;
  var j1:=0;
  //dictionary inittialy filled with 8-bit bytes
  while j1<256
    invariant (if(j1<=255)then (j as int)==j1 else (j as int)<j1) && 0<=j1<=256 
    decreases 256 - j1;
  {
    var entry:=[];
    entry:= entry + [j];  
    table[j] := entry;
    if(j1<255){
      j:=j+1;}
    j1:=j1+1;
  }
  var i := 0;
  var counter:=256;
  var b2:bool;
  while i < data.Length
    decreases data.Length-i;
    modifies table;
    {
      b2:=contains(table, s + [data[i]]);
        if(b2==true){
            s := s + [data[i]];
        }
        else{
            if(counter<8192){
              table[counter] := s + [data[i]];
              var l: int;
              var h: seq<byte>;  
              l:= lookup(table, s);
              h:=convertBin(l);
              out := out + h;
              s := [data[i]];
              counter:= counter +1;
            }
        }
    i := i + 1; //
  }
 
}


  method contains(a: array<seq<byte>>, n: seq<byte>) returns (res:bool)
{
  var flag :bool:=true;
  var counter:int:=0;
  while counter<a.Length
  decreases a.Length - counter
  {
    if SeqEquals(a[counter],n){
      flag:=false;
      res:=true;
    }
    else{
      if (counter==a.Length)
      {
        res:=false;}
    }
    counter:=1+counter;
  }
}

function method eqbytes(a:seq<byte>, b:seq<byte>):bool
    {
        ((|a|==|b|) && (forall i:: (0<=i<|a|) ==> a[i]==b[i])) 
    }

method lookup(a: array<seq<byte>>, n: seq<byte>) returns (num:int)
{
  var flag :bool:=true;
  var counter:int:=0;
  while counter<a.Length
  decreases a.Length-counter
  {
    if SeqEquals(a[counter],n){
      num:=counter;
      flag:=false;
    }
    counter:=1+counter;
  }
}

function method SeqEquals(a: seq<byte>, b: seq<byte>):bool
//requires n!=[];
//requires forall i::0<=i<|a| ==> a[i]!=[]; 
decreases |a|
decreases |b|
{
  if |a|!=|b| then false else
  if |a|==0 || |b|==0 then true else
  if a[0]==b[0] then
  true && SeqEquals(a[1..], b[1..]) else false
}

method convertBin(i:int) returns (b:seq<byte>)
//requires 0<=i<=65535
{
  var b1:byte:=0;
  var q:=i;
  var j:=0;
  //assert 0<= q <=65535;
  var powerArray := [1,2,4,8,16,32,64,128];
  var numero:int:=0;

  while j<8
  decreases 8-j
  {
    var p:int;
    
    if(q%2==1){
      p:=powerArray[j];
      numero:=numero + p;
      }
    
    q:=q/2;
    j:=j+1;
  }
  
  if(0<=numero<=255){
    b1:= numero as byte;
    }
  if(0<=q<=255){
    b:=[b1]+[q as byte];
  }
}