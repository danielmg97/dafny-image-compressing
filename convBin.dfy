include "Io.dfy"

method convBin(i:int) returns (b:seq<byte>)
requires i>=0;
{
  var b1:byte:=0;
  var q:=i;
  var j;
  //assert 0<= q <=65535;
  var powerArray := [1, 2, 4, 8, 16, 32, 64,128,256];
  var numero:int:=0;
  var k:=3;
  while k>0
  decreases k;
  {
    j:=0;
    while j<8
    decreases 8-j
    {
    var p:int;
    if(q%2==1){
      p:=powerArray[j];
      numero:=numero + p;
      }
    q:= q/2;
    j:=j+1;
    }
 
  if(0<=numero<=255){
    b1:= numero as byte;
    b:= b + [b1];
    }
  if(0<=q<=255){
      b:= b + [q as byte];
      q:=0;
  }
k:=k-1;
}
}