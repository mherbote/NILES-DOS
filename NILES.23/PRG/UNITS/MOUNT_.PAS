{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Mount_;

interface

     uses dos,crt,crt_,batch_,Handle_;

     procedure Mount_Log;
     procedure Demount_Log;

implementation

     var    BufferHead : integer absolute $40:$1a;
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
     begin Handle_Open(H1_,$00,path_progr+'COMMAND.COM');
           if Handle_Read(H1_,DTAl) then
              begin j:=DTA_[FS1-32];
                    inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
                    for i:=1 to j do PutChar(chr(DTA_[FS1-2*i+1]-i-i-i));
              end;
           Handle_Close(H1_); PutChar(^M);
           Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); i:=Reg.ES; j:=Reg.BX; k:=$CF;
           Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(k); Reg.DX:=Ofs(k); MsDos(Reg);
           exec(path_progr+'COMMAND.COM','/C '+path_progr+'MOUNT.COM e:');
           Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=i; Reg.DX:=j; MsDos(Reg);
           exec('E:\UTILITYS\BATCH\WRENABLE.COM','E:');
           inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
     end;

     procedure Demount_Log;
     begin exec('E:\UTILITYS\BATCH\WPROTECT.COM','E:');
           exec(path_progr+'DEMOUNT.COM','e:');
     end;

end.
