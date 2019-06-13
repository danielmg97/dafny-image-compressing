include "Io.dfy"
include "convInt.dfy"
method decompress(c:array?<byte>)returns(o:array<byte>, t:array<seq<byte>>)
requires c.Length>0;
{
    var neb;//number of bytes that encodes the length of the coded text
    
    neb:= c[c.Length-1] as int;
    
    var encoded_length;
    if(c.Length>(neb+1) && ((c.Length - 1)>(c.Length - (neb + 1)))){
         encoded_length:= convInt(c[((c.Length-1) - (neb))..(c.Length-1)]); //coded text length
    }
    if(encoded_length>0){
    o:=new byte[encoded_length];}
    //assume 0< (c.Length - (neb + 1)) && (c.Length - (neb + 1))<c.Length-1;
    var j:=0;
    while j <encoded_length
    decreases encoded_length -j
    {
        if(j<c.Length){
        o[j]:= c[j];

        }
        j:=j+1;
    }
    t:= new seq<byte>[8192];
    var f:=0;
    var g;
    if(c.Length>j+2){
        g:=convInt([c[j]]+[c[j+1]]);
    }

    while j < c.Length -1
    decreases c.Length -j;
    {
        
        
        g:=convInt([c[j], c[j+1]]);
        if (j+g+2<c.Length && g>0 && f<t.Length){
            t[f] := c[j+2..j+g+2];
        }
        if(g>=0){
            j:=j + g + 2;
        }else{
            j:=j+2;
        }
                    

        
        f:= f+1;
    }
}

