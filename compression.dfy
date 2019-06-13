/*  
 * This is the skeleton for your compression and decompression routines.
 * As you can see, it doesn't do much at the moment.  See how much you 
 * can improve on the current algorithm! 
 *
 * Rui Maranhao -- rui@computer.org
 */

include "Io.dfy"
include "comp.dfy"
include "compress.dfy"
include "decompress.dfy"
include "convBin.dfy"

/*
function compress(bytes:seq<byte>) : seq<byte>
{
  bytes
}*/
/*
function decompress(bytes:seq<byte>) : seq<byte>
{
  bytes
}*/

/*
lemma lossless(bytes:seq<byte>)
  ensures decompress(compress(bytes)) == bytes;
{
}*/
/*
method compress_impl(bytes:array?<byte>) returns (compressed_bytes:array?<byte>)
  requires bytes != null;
  ensures  compressed_bytes != null;
  ensures  compressed_bytes[..] == compress(bytes[..]);
{
  compressed_bytes := bytes;
}*/
/*
method decompress_impl(compressed_bytes:array?<byte>) returns (bytes:array?<byte>)
  requires compressed_bytes != null;
  ensures  bytes != null;
  ensures  bytes[..] == decompress(compressed_bytes[..]);
{
  bytes := compressed_bytes;
}*/

method {:main} Main(ghost env:HostEnvironment?)
  modifies env.ok
  modifies env.files
  requires env != null && env.Valid() && env.ok.ok();
{
  var argNum := HostConstants.NumCommandLineArgs(env);        //verificamos o numero de argumentos |(cp.exe file1 file2)| == 3
  if argNum != 4 {
    print "Incorrect number of arguments! One source and one destination file needed.";
    return;
  }
  var opt := HostConstants.GetCommandLineArg(1,env);
  var src := HostConstants.GetCommandLineArg(2,env);
  var dst;
  if(argNum==4){
  dst := HostConstants.GetCommandLineArg(3,env);}

  var srcResult := FileStream.FileExists(src,env);
  var dstResult := FileStream.FileExists(dst,env);
  if !srcResult {                                             //verificamos que o ficheiro src existe
    print "Source file does not exist!";
    return;

  }
    if dstResult {                                            //verificamos se o ficheiro de destino já existe (cp-basic não dá overwrite)
    print "Destination file already exists!";
    return;

  }

  var srcSuccess, srcFs := FileStream.Open(src,env);
  if !srcSuccess {                                            //verificamos se abriu a source bem
    print "Failed to open source file!";
    return;
  }

  var dstSuccess, dstFs := FileStream.Open(dst,env);
  if !dstSuccess {                                           //verificamos se abriu o destino bem
    print "Failed to open destination file!";
    return;
  }

  var success, len : int32 :=FileStream.FileLength(src,env);
  if !success {
    print "Couldn't get file size!";
    return;
  }

if(opt.Length>0){
    if(opt[0]=='1'){
    var buffer, srcOk, dstOk := new byte[len],true,true;
    srcOk := srcFs.Read(0,buffer,0,len);
        print len;
    var s, chars := encode(buffer);
    var compi:= compress(s, chars);
    //print compi[..];
    if (srcOk && compi.Length>0 && compi.Length< 0x80000000){ 
      print(compi[..]);
      dstOk := dstFs.Write(0,compi,0,(compi.Length as int32));
    }
  }
  if(opt[0]=='0'){
    var buffer, srcOk, dstOk := new byte[len],true,true;
    srcOk := srcFs.Read(0,buffer,0,len);
    
    var o:array<byte>;
    var t;
    if(buffer.Length>0){
      o, t:= decompress(buffer);
    }
    if (srcOk && o.Length>0 && o.Length< 0x80000000){ 
      print(o[..]);
      dstOk := dstFs.Write(0,o,0,(o.Length as int32));
    }
    }
  }
}