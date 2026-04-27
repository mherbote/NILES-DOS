{$R-,S-,I-,D-,F-,V+,B-,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

program CRC;

  uses  crt,dos,Handle_,Environ_;

  const DLN ='CRC.';                     {Dateilisten-Name}

  var   ComSpec,h1,h2  : String[255];
        crcd           : File of Byte;
        hhh            : File;
        f,f1           : Text;
        lw             : String;
        w,ag           : Word;
        crcb           : Boolean;
        i              : Integer;
        crcc           : Byte;
        crcs,j         : Word;

function HexB(b:Byte):String;
const hex_array:array [0..15] of char='0123456789ABCDEF';
begin HexB:=hex_array[b shr 4]+hex_array[b and $0f]; end;

function HexBB(b:Byte):Byte;
const hex_array:array [0..15] of Byte=(0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15);
begin HexBB:=hex_array[b shr 4]*10+hex_array[b and $0f]; end;

function BHexB(b:Byte):Byte;
  var i:Integer;
begin i:=b div 10; BHexB:=i*16+(b-i*10); end;

procedure crc_b;
begin       inline($8B/$1E/crcs /         {   MOV   BX,[crcs]   }
                   $8A/$C7/               {   MOV   AL,BH       }
                   $24/$80/               {   MOV   AL,80H      }
                   $9F/                   {   LAHF              }
                   $03/$DB/               {   ADD   BX,BX       }
                   $02/$1E/crcc /         {   ADD   BL,[next_B] }
                   $9E/                   {   SAHF              }
                   $74/$04/               {   JE    M1          }
                   $81/$F3/$97/$A0/       {   XOR   BX,0A097h   }
                   $89/$1E/crcs           {   MOV   [crcs],BX   }
                  );
end;

  function Attribute(a:byte):String;
    const wrt : Array[1..4] of Byte=(  1,  2,  4, 32);
          nam : Array[1..4] of Char=('R','H','S','A');
    var   i   : Integer;
          h3  : String;
  begin h3:='';
        for i:=1 to 4 do if (a and wrt[i])>0 then h3:=h3+nam[i]
                                             else h3:=h3+' ';
        Attribute:=h3;
  end;

  procedure ErzeugeListe(pfad:string);
    var Such  : SearchRec;
        Such1 : record Fill : Array[1..21] of Byte;
                       Attr :                 Byte;
		       t2,t1:                 Word;
                    (* Time :                 LongInt; *)
                       Size :                 LongInt;
                       Name :                 String[12];
                 end ABSOLUTE Such;
        i,p  : Integer;
	hT   : LongInt;
        Attr1: Byte;
  begin GotoXY(1,wherey); delline; write(lw+pfad);
        exec(ComSpec+'COMMAND.COM','/C CD '+lw+copy(pfad,1,length(pfad)-1)+' >NUL');
        findfirst(lw+pfad+'*.*',AnyFile,Such);
        while Doserror=0 do
              begin if (Such.Attr and Directory)=0 then
                       begin gotoxy(1,wherey); delline; write(lw+pfad+Such.Name);
                             Attr1:=Such.Attr;
                             Assign(hhh,lw+Such.Name);
                             crcs:=0; i:=$80; Handle_Open(H1_,$00,lw+Such.Name);
                             while (Handle_Read(H1_,DTAl)) and (FS1>0) do
                                   for j:=1 to FS1 do
                                       begin crcc:=DTA_[j];
                                             i:=i-1; if i=0 then i:=$80;
                                             crc_b;
                                       end;
                             Handle_Close(H1_); crcc:=0;
                             if i<>$80 then
                                while i>0 do begin crc_b; i:=i-1; end;
                             Write  (f,lw+pfad); h2:=lw+pfad;
                             for i:=1 to 40-length(h2) do Write(f,' ');
                             if pos('.',Such.Name)=0
                                then begin Write(f,Such.Name);
                                           for i:=1 to 8-length(Such.Name) do Write(f,' ');
                                           Write(f,'.   ');
                                     end
                                else begin Write(f,copy(Such.Name,1,pos('.',Such.Name)-1));
                                           for i:=1 to 9-pos('.',Such.Name) do Write(f,' ');
                                           Write  (f,copy(Such.Name,pos('.',Such.Name),4));
                                           i:=length(Such.Name)-pos('.',Such.Name);
                                           while i<3 do begin Write(f,' '); i:=i+1; end;
                                     end;
                             Write  (f,' (',Such.Size:7); hT:=Such1.T1;
                             Write  (f,',',           (hT and   $1F)      :2);
                             Write  (f,'.',round(     (hT and  $1E0)/32):2); hT:=hi(Such1.T1);
                             Write  (f,'.',round(1980+(hT and   $FE)/ 2):4); hT:=hi(Such1.T2);
                             Write  (f,',',round(     (hT and   $F8)/ 8):2); hT:=   Such1.T2;
                             Write  (f,':',round(     (hT and  $7E0)/32):2);
                             Write  (f,':',           (hT and   $1F)    :2);
                             Write  (f,',[',Attribute(Attr1),']) ');
                             Writeln(f,'= ',HexB(hi(crcs)),HexB(lo(crcs)));
                       end;
                    FindNext(Such);
              end;
        findfirst(lw+pfad+'*.*',AnyFile,Such);
        while Doserror=0 do
              begin if (Such.Attr and Directory)>0 then
                       begin if (Such.Name<>'.') and (Such.Name<>'..') then
                                ErzeugeListe(pfad+Such.Name+'\');
                             GotoXY(1,wherey); DelLine; Write(lw+pfad);
                       end;
                    FindNext(Such);
              end;
  end;


begin ComSpec:=SearchEnvironment('COMSPEC'); delete(ComSpec,1,pos('=',ComSpec));
      delete(ComSpec,pos('COMMAND',ComSpec),length(ComSpec)-pos('COMMAND',ComSpec)+1);
      Writeln; Writeln(' CRC V1.0  (C) 1988 NILES-Soft');
      if paramcount>0 then lw:=copy(paramstr(1),1,2) else lw:='';
      lw[1]:=upcase(lw[1]);
      if (not (lw[1] in ['A'..'Z'])) or (lw[2]<>':') then
         begin Writeln; Writeln('Aufruf:  CRC [laufwerk]:, z.B.: CRC c:');
               Writeln; halt(1);
         end;
      Writeln;
      Writeln('Prfsummen-Liste von ',ParamStr(1),ParamStr(2),'... wird erzeugt...');
      Writeln;
      Assign(f,'\'+DLN);
      Rewrite(f); if ParamCount>1 then ErzeugeListe(ParamStr(2)) else ErzeugeListe('\');
      Close(f);
      exec(ComSpec+'COMMAND.COM','/C SORT <\'+DLN+' >\'+DLN+lw[1]);
{      Erase(f);}
      GotoXY(1,wherey); DelLine; Writeln('Fertig.'); Writeln;
 end.
