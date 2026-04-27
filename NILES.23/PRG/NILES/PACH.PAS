{$R-,S-,I-,D+,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * PACH.PAS       Path / Append CHange                *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,Editz_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     P  A  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '27.03.89';

var    i,iP                        :           Integer;
       Code,lng                    :           Word;
       wei                         :           Boolean;
       reg                         :           Registers;
       ComSpec,hilf,par2,par3,par4 :           String;
       ch                          :           Char;

procedure sys_halt(id:Integer);
begin sys_halt1(id); halt(99); end;

function HexB(b:Byte):String;
const hex_array:array [0..15] of char='0123456789ABCDEF';
begin HexB:=hex_array[b shr 4]+hex_array[b and $0f]; end;

function cw(cws:Word; cwo:Integer):Word;
begin cw:=mem[cws:cwo+1]*256+mem[cws:cwo]; end;

procedure dump; var i,j,k:byte;
begin for k:=0 to 3 do
      begin for i:=0 to 3 do
            begin for j:=0 to 3 do Write(HexB(mem[Code:k*16+i*4+j]),' ');
                  Write(' ');
            end;
            for i:=0 to 15 do Write(chr (mem[Code:k*16+i]));
            Writeln;
      end;  Writeln;
end;

procedure hole_app;
  var tdat : Text;
begin exec(ComSpec,'/C APPEND >c:\bat\$$$$$$$$.$$$');
      Assign(tdat,'C:\bat\$$$$$$$$.$$$'); Reset(tdat);
      Readln(tdat,EditStr); Close(tdat); Erase(tdat);
      delete(EditStr,1,pos('=',EditStr));
end;

procedure del_var(par3:String);
  var i,j  : Integer;
      hilf : String;
begin i:=0;
      repeat hilf:=''; j:=i;                           { Variable finden }
             while mem[Code:i]<>ord('=') do
             begin hilf:=hilf+chr(mem[Code:i]); i:=i+1; end;
             while mem[Code:i]<>0 do i:=i+1; i:=i+1;
      until hilf=par3;
      while mem[Code:i]<>0 do
      begin while mem[Code:i]<>0 do
            begin mem[Code:j]:=mem[Code:i]; j:=j+1; i:=i+1; end;
            mem[Code:j]:=0; j:=j+1; i:=i+1; Writeln;
      end;  mem[Code:j]:=0;
end;

procedure add_var(par3,hilf:String);
  var i,j  : Integer;
begin i:=0;
      while mem[Code:i]<>0 do                          { Var-Ende suchen    }
      begin while mem[Code:i]<>0 do i:=i+1; i:=i+1; end;
      for j:=1 to Length(par3) do
          if i<lng-2 then begin mem[Code:i]:=ord(par3[j]); i:=i+1; end;
      if i<lng-2 then begin mem[Code:i]:=ord('='); i:=i+1; end;
      for j:=1 to Length(hilf) do
          if i<lng-2 then begin mem[Code:i]:=ord(hilf[j]); i:=i+1; end;
      mem[Code:i]:=0; mem[Code:i+1]:=0;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      par2:=ParamStr(2); par3:=ParamStr(3); ComSpec:=GetEnv('COMSPEC');
      while i<Length(par3) do begin i:=i+1; par3[i]:=UpCase(par3[i]); end;
      reg.AH:=$62; MsDos(reg); Code:=reg.BX;           { akt. PSP           }
                               Code:=cw(Code,$0C);     { oberer PSP ?       }
                               Code:=cw(Code,$2C);     { oberes Environment }
      lng:=mem[Code-1:4]*256+mem[Code-1:3]*16;
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then       clrscr
         else begin Window(7,6,75,18); clrscr; Window(1,1,80,25); end;
      if UpCase(par2[1])='S' then
         fenster(1, 7, 6,75,18,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      case upcase(par2[1]) of
      'S': if par3='APPEND'
              then begin hole_app;
                         Window( 1, 1,80,25); EditZ(-1,10,10,72,17);
                         exec(ComSpec,'/C APPEND '+EditStr);
                   end
              else begin EditStr:=GetEnv(par3);
                         Window( 1, 1,80,25); EditZ(-1,10,10,72,17); i:=0;
                         if Length(EditStr)>0 then
                            begin repeat i:=i+1; until (EditStr[i+1]=' ') or (i=Length(EditStr));
                                  EditStr[0]:=chr(i);
                            end;
                         del_var(par3); add_var(par3,EditStr);
                   end;
      'A': if par3='APPEND'
              then begin if ParamCount<4 then halt(99); hole_app;
                         exec(ComSpec,'/C APPEND '+EditStr+ParamStr(4));
                   end
              else begin if ParamCount<4 then halt(99);
                         EditStr:=GetEnv(par3); Delete(EditStr,1,pos('=',EditStr));
                         del_var(par3); add_var(par3,EditStr+ParamStr(4));
                   end;
      'C': if par3='APPEND'
              then begin if ParamCount<5 then halt(99); hole_app;
                         i:=pos(ParamStr(4),EditStr);
                         Delete(EditStr,i,Length(ParamStr(4)));
                         Insert(ParamStr(5),EditStr,i);
                         exec(ComSpec,'/C APPEND '+EditStr);
                   end
              else begin if ParamCount<5 then halt(99);
                         EditStr:=GetEnv(par3); Delete(EditStr,1,pos('=',EditStr));
                         i:=pos(ParamStr(4),EditStr);
                         Delete(EditStr,i,Length(ParamStr(4)));
                         Insert(ParamStr(5),EditStr,i);
                         del_var(par3); add_var(par3,EditStr);
                   end;
      'D': if par3='APPEND'
              then begin if ParamCount<4 then halt(99); hole_app;
                         Delete(EditStr,pos(ParamStr(4),EditStr),Length(ParamStr(4)));
                         exec(ComSpec,'/C APPEND '+EditStr);
                   end
              else begin if ParamCount<4 then halt(99);
                         EditStr:=GetEnv(par3); Delete(EditStr,1,pos('=',EditStr));
                         Delete(EditStr,pos(ParamStr(4),EditStr),Length(ParamStr(4)));
                         del_var(par3); add_var(par3,EditStr);
                   end;
      end;

      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin Window( 7, 6,75,18); clrscr; Window(1,1,80,25); end;
      halt(0);
end.
