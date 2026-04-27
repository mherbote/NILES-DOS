{$A-,B+,D-,E+,F-,I-,L-,N-,O-,R-,S-,V+}
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit nim_;

interface

     uses crt,dos,Lognam1_,Mount_,SysLog_,Syshalt_;

     procedure nim;

implementation

var i,j,k,l,anz    : Integer;
    ii,jj,kk       : Integer;
    ComSpec,formal : String;
    BufferHead     : Integer absolute $40:$1a;
    BufferTail     : Integer absolute $40:$1c;
    Reg            : Registers;

procedure PutChar(c:char);
begin inline($FA);    { Disable Interrupts }
      memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+2;
      if BufferTail>=$3E then BufferTail:=$1E;
      inline($FB);    { Enable  Interrupts }
end;

procedure sys_halt(id:integer);
begin Demount_Log; Sys_halt1(id); halt(1); end;

procedure log;
begin SysLog_O; if not SysLog_exit then sys_halt(4);
      Seek(SysLog_d,FileSize(SysLog_d)-1); SysLog_R; SysLog_C;
      formal:=SysLog_p.bea;
end;

procedure nim;
begin ComSpec:='d:\utilitys\batch\command.com';
      Mount_Log; log; LogNam1_O(anz);
      for i:=1 to anz do
          if LogNam1_p.bkz[i]=formal then
             begin j:=1;
                   repeat if LogNam1_p.lwl[i][j]<>' ' then
                             begin inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
                                   k:=1; l:=ord(UpCase(LogNam1_p.lwl[i][j]))-ord('F');
                                   repeat PutChar(LogNam1_p.pw[l][k]); k:=k+1;
                                   until LogNam1_p.pw[l][k]='ê';
                                   PutChar(^M);
                                   Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); ii:=Reg.ES; jj:=Reg.BX; kk:=$CF;
                                   Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(kk); Reg.DX:=Ofs(kk); MsDos(Reg);
                                   exec(ComSpec,'/C '+'D:\UTILITYS\BATCH\MOUNT.COM '+
                                        UpCase(LogNam1_p.lwl[i][j])+':');
                                   Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=ii; Reg.DX:=jj; MsDos(Reg);
                                   inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
                             end;
                          j:=j+1;
                   until LogNam1_p.lwl[i][j]=' ';
             end;
      Demount_Log; LogNam1_L;
end;

end.
