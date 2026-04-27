{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * DBATCH.PAS                              *
 * l”schen bzw. kopieren von Pfaden        *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,fenster_,Batch_,Handle_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     D  B  A  T  C  H';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

var   par1,par2,par3 : string[255];

procedure del_path(path:str12);
  var i     :               Word;
      S_Rec : { record Fill : Array[1..21] of Byte;
                       Attr : Byte;
                       Time : LongInt;
                       Size : LongInt;
                       Name : String[12];
                end}
              SearchRec;
      name  :               String[ 12];
      Attr  :               Word;
      ch    :               Byte;
      Datei :               File of Byte;
begin name:=''; FindFirst(path+'*.*',ReadOnly+Hidden+SysFile,S_Rec);
      while (name<>S_Rec.Name) and (DosError=0) do
      begin name:=S_Rec.Name;
{$IFDEF Debug} writeln('DELETE:',S_Rec.Name); {$ENDIF}
            Assign(Datei,path+name); SetFAttr(Datei,Archive);
            Handle_Open(H1_,$00,path+name); Handle_Create(H2_,$00,path+name);
            while (Handle_Read(H1_,50*1024)) and (FS1>0) do
            begin for i:=1 to FS1 do DTA_[i]:=random(256);
                  Handle_Write(H2_,FS1);
            end;
            Handle_Close(H1_); Handle_Close(H2_); Erase(Datei);
            FindNext(S_Rec);
      end;
end;

procedure copy_path(path1,path2:str12);
  var i     :               integer;
      S_Rec : { record Fill : array[1..21] of byte;
                       Attr : Byte;
                       Time : LongInt;
                       Size : LongInt;
                       Name : string[12];
                end}
              SearchRec;
      name  :               string[ 12];
      Attr  :               Word;
begin name:=''; FindFirst(path1+'*.*',0,S_Rec);
{$IFDEF Debug} write(path1,'\',name,'.',S_Rec.Name,'.',DosError); Readln; {$ENDIF}
      while (name<>S_Rec.Name) and (DosError=0) do
      begin name:=S_Rec.Name;
{$IFDEF Debug} write('COPY:',S_Rec.Name,'   '); {$ENDIF}
            assign(out,path2+name);
            Handle_Open(H1_,$00,path1+name); Handle_Create(H2_,$00,path2+name);
            while (Handle_Read(H1_,50*1024)) and (FS1>0) do Handle_Write(H2_,FS1);
            Handle_Close(H1_); Handle_Close(H2_); Attr:=Archive;
            if pos('R',ParamStr(4))>0 then Attr:=Attr+ReadOnly;
            if pos('H',ParamStr(4))>0 then Attr:=Attr+Hidden  ;
            if pos('S',ParamStr(4))>0 then Attr:=Attr+SysFile ;
{$IFDEF Debug} writeln(Attr); {$ENDIF}
            SetFAttr(out,Attr);
            FindNext(S_Rec);
      end;
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      par1:=ParamStr(1); par2:=ParamStr(2); par3:=ParamStr(3);
{$IFDEF Debug}
clrscr; writeln(ParamStr(1)); writeln(ParamStr(2)); writeln(ParamStr(3));
        writeln(ParamStr(4));
exec('d:\utilitys\batch\command.com','/c dir e:');
Readln;
{$ENDIF}
      case upcase(par1[1]) of
      'D': del_path(par2);
      'C': copy_path(par2,par3);
      end;
end.
