include "Io.dfy"
include "convInt.dfy"

method decode (encoded: seq<byte>, dictionary: array<seq<byte>>)returns(s:seq<byte>)
requires |encoded|%2==0;
requires |encoded|>0;
{
    var j:=0;
    var i:int;
    while j< |encoded|-1
    decreases |encoded|-j
    {
        i:=convInt([encoded[j], encoded[j+1]]);
        assume 0<=i < dictionary.Length;
        s := s + dictionary[i];
        j:=j+1;
    }
}