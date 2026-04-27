{$R-,S+,I+,D-,F-,V+,B-,N-,L+ }
{$M 1500,0,0 }
{$define Debug }
uses dos,crt;

var e     : string[255];
    di,da : text;

const cii = 'd:\doc\ws4\msh\i\';
      coo = 'f:\doc\';

begin clrscr;
      assign(di,cii+ParamStr(1)+'.i'); reset  (di);
      assign(da,coo+ParamStr(1)     ); rewrite(da);
      repeat readln (di,e); while pos(#10,e)<>0 do delete(e,pos(#10,e),1);
             if length(e)>0 then begin writeln(da,e); writeln(e); end;
      until eof(di);
      close(di); close(da); erase(di); 
end.
