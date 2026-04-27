{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit GNR_;

Interface

  uses dos,Handle_,LogNam_;

  function Geraete_Nummer : String;

Implementation

  function Geraete_Nummer : String;
    var byt2,i     : Integer;
        hhh        : String;
        BufferHead : integer absolute $40:$1a;
        BufferTail : integer absolute $40:$1c;
     procedure PutChar(c:char);
     begin inline($FA); { Disable Interrupts }
           memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+2;
           if BufferTail>=$3E then BufferTail:=$1E;
           inline($FB);    { Enable  Interrupts }
     end;
     procedure Mount_Log;
       var Reg   : Registers;
           i,j,k : Word;
           bbb   : Byte;
           comm  : file of Byte;
     begin Handle_Open(H1_,$00,'D:\UTILITYS\BATCH\COMMAND.COM');
           if Handle_Read(H1_,DTAl) then
              begin j:=DTA_[FS1-32];
                    inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
                    for i:=1 to j do PutChar(chr(DTA_[FS1-2*i+1]-i-i-i));
              end;
           Handle_Close(H1_); PutChar(^M);
           Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); i:=Reg.ES; j:=Reg.BX; k:=$CF;
           Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(k); Reg.DX:=Ofs(k); MsDos(Reg);
           exec('D:\UTILITYS\BATCH\COMMAND.COM','/C '+'D:\UTILITYS\BATCH\MOUNT.COM e:');
           Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=i; Reg.DX:=j; MsDos(Reg);
           exec('E:\UTILITYS\BATCH\WRENABLE.COM','E:');
           inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
     end;
     procedure Demount_Log;
     begin exec('E:\UTILITYS\BATCH\WPROTECT.COM','E:');
           exec('D:\UTILITYS\BATCH\DEMOUNT.COM','e:');
     end;
  begin Mount_Log; hhh:='';
        LogNam_O; Seek(LogNam_d,0); LogNam_R; byt2:=LogNam_p.byt[12]; LogNam_R;
        for i:=1 to 14 do
            begin hhh:=hhh+chr(LogNam_p.byt[i]-i+byt2);
                  byt2:=byt2+2*i+i;
            end;
        Demount_Log; Geraete_Nummer:=hhh;
  end;

end.
