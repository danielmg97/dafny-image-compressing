include "Io.dfy"
include "comp.dfy"
include "convBin.dfy"

/*
method {:main} Main ()
{
  var s, chars := encode([1, 2, 3, 20, 20, 30, 200, 201, 20, 20, 1]);
  //print(s);
  //print(chars);
    var a := compress(s, chars);
print a[0..];
}*/

method compress(o:seq<byte>, d:array<seq<byte>>)returns(r:array<byte>)
{
    var c:seq<byte>;
    c:=o;
    var t:seq<byte>;
    var j:=0;
    while j<d.Length
    decreases d.Length-j
    {
        var b:byte;
        if(0<=|d[j]|<=255){
            b:=(|d[j]| as byte);
            c:=c + [b] + d[j];
        }
        j:=j+1;
    }
    var l:= convertBin(|o|);
    if(0<=|l|<=255){
        c:=c+l +[(|l| as byte)];
    }
    r:= new byte[|c|];
    var k:=0;
    while k <|c|
    decreases |c|-k
    { 
        r[k]:= c[k];
        k:=k+1;
    }
}
