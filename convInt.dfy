include "Io.dfy"

/*
method {:main} Main(){
    var b:seq<byte>;
    b:= b + [1, 30, 20];
    var coiso:= convInt(b);
    print(coiso);
}
*/

method convInt(b:seq<byte>)returns(i:int)
requires |b|>=1;
//ensures 0<=i<65536;
{
    if(|b|==1){
    i:=(b[0] as int);}
    else{
        i:= (b[0] as int);
        var w:=1;
        while w < |b|
        decreases |b| - w;
        {
            var b2:=b[w];
            var p:int:= (b[w] as int); 
            var j:=0;
            while j<8
            decreases 8-j
            {
                if(p%2==1){
                    i:=i + power(j + 8*w);
                }
                p:=p/2;
                j:=j+1;
            }
            w:=w+1;
        }   

    }    
}

function method power(e:int):int
requires 0<=e;
decreases e;
{
   if (e==0) then 1 else 2*power(e-1)
}

