{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * IBATCH1.PAS                             *
 * Modifikation von COMMAND.COM            *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,SysLog_,LogNam_,Mount1_,Handle_,Wahl_,EditZ_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     I  B  A  T  C  H  1';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '15.09.89';

var    i,j,k,DEC,Name_I            :               Integer;
       _j,_k,i_j,i_k               :               Byte;
       S_Rec                       : { record Fill : array[1..21] of byte;
                                              Attr : Byte;
                                              Time : LongInt;
                                              Size : LongInt;
                                              Name : string[12];
                                       end}
                                     SearchRec;
       Name                        : array[1..    7] of string[ 13];
       Name_C                      : array[1..   40] of string[ 13];
       Name_A                      : array[1..   40] of string[ 13];
       Name_N                      : array[1..   40] of string[ 13];
       path_d     ,path_progr      :                    string[ 80];
       path_progr2,path_progr3     :                    string[ 80];
       Attr                        :                    Word;
       bbb,byt2                    :                    Byte;
       comm,idat                   : file            of Byte;
       config                      :                    Text;
       First                       :                    Boolean;
       hilf,hilf1,command,gken,liz :                    string[255];
       J1,J2,M,M1,M2,D1,D2,D11     :                    Word;
       S1,N1,T1                    :                    Word;
       Name_,Pass1,Pass2           :                    string;
       hilfc                       : array[0..  255] of byte absolute hilf;
       Reg                         :                    Registers;
       BufferHead                  :                    Integer absolute $40:$1a;
       BufferTail                  :                    Integer absolute $40:$1c;
       ii,iii                      :                    LongInt;
       ok                          :                    Char;
       mmm                         :                    Boolean;

procedure Sys_Halt(id:Integer);
begin Sys_Halt1(id); {$IFDEF Debug} halt(1); {$ELSE} i:=0; while i=0 do ; {$ENDIF} end;

procedure PutChar(c:char);
begin inline($FA); { Disable Interrupts }
      memw[$40:BufferTail]:=ord(c); BufferTail:=BufferTail+2;
      if BufferTail>=$3E then BufferTail:=$1E;
      inline($FB);    { Enable  Interrupts }
end;

function NextByte_idat:Char;
  var ch:Byte;
begin Read(idat,ch); NextByte_idat:=chr(ch-i_j-i_j+i_k); i_k:=i_k+i_j; end;

function NextString:string;
  var ch  : Char;
      Str : string[255];
begin Str[0]:=#0;
      repeat ch:=NextByte_idat;
             case ch of #10: ;
                        #13: ch:=#255;
                        ',': ch:=#255;
                        else begin Str[        0  ]:=chr(ord(Str[0])+1);
                                   Str[ord(Str[0])]:=ch;
                             end
             end;
      until ch=#255;
      NextString:=Str;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);
{ Modifikation von  COMMAND.COM }
      repeat repeat hilf:='..............';
                    c1_write( 8,10,'PassWord von Laufwerk E eingeben      :');
                    c2_write( 8,50,hilf);
                    GotoXY(50, 8); Readln(hilf);
             until (length(hilf)>4) and (length(hilf)<15);
             c1_write( 8,50,'**************');
             inline($FA); BufferHead:=$1E; BufferTail:=$1E; inline($FB);
             j:=length(hilf); for i:=1 to j do PutChar(hilf[i]); PutChar(^M);
             Reg.AH:=$35; Reg.AL:=$10; MsDos(Reg); i:=Reg.ES; j:=Reg.BX; k:=$CF;
             Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=Seg(k); Reg.DX:=Ofs(k); MsDos(Reg);
             exec('C:\DEMOUNT.COM','e:'); exec('C:\MOUNT.COM','e:');
             DEC:=DosExitCode;
             Reg.AH:=$25; Reg.AL:=$10; Reg.DS:=i; Reg.DX:=j; MsDos(Reg);
             if DEC=1 then
                begin c1_write( 1, 1,''); Window( 9, 9,79,23); clrscr;
                      c2_write(10,10,'Falsches PassWort eingegeben');
                      c1_write(15,20,'<ENTER> fÅr weiter !');
                      Readln;
                      c1_write( 1, 1,''); Window( 9, 9,79,23); clrscr;
                      Window( 1, 1,80,25);
                end;
      until DEC=0;
      Assign(comm,'D:\UTILITYS\BATCH\COMMAND.COM'); SetFAttr(comm,Archive); Reset(comm);
      k:=FileSize(comm); j:=k-(k div 128)*128;
      if j<64 then for i:=k to k+128 do
                       begin Seek(comm,i); bbb:=Random(255); Write(comm,bbb); end
              else for i:=k to k+j   do
                       begin Seek(comm,i); bbb:=Random(255); Write(comm,bbb); end;
      bbb:=length(hilf); Seek(comm,FileSize(comm)-33); Write(comm,bbb);
      for i:=1 to length(hilf) do
          begin bbb:=hilfc[i]+i+i+i; Seek(comm,FileSize(comm)-2*i); Write(comm,bbb); end;
      Close(comm);
end.
