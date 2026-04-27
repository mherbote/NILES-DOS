{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5000,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{******************************************************
 * IBH1.PAS       Install Help 1 fÅr NILES-DOS        *
 *                erzeugt die INSTALL.DAT (Quelle)    *
 *                                                    *
 *                   (c) by NILES-SOFT 1988 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses   dos,crt,crt_,Fenster_,Syshalt_,Editz_,Wahl_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     I  B  H  1';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '02.05.89';
       wanz                        = 13;

var    i,iP,iZ1,iZ                 :           Integer;
       datum                       : record Tag,Monat,Jahr,Wday : Word; end;
       Code,lng                    :           Word;
       wei                         :           Boolean;
       reg                         :           Registers;
       dati,dato                   :           Text;
       ComSpec,hilf,par2,par3,par4 :           String;
       ch                          :           Char;

procedure sys_halt(id:Integer);
begin sys_halt1(id); halt(99); end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      val(ParamStr(1),iZ1,Code);
      par2:=ParamStr(2); par3:=ParamStr(3); ComSpec:=GetEnv('COMSPEC');
      with datum do GetDate(Jahr,Monat,Tag,Wday);
      clrscr;
      fenster(1, 1, 1,80,24,'…','Õ','ª','∫','»','º','∫','Õ',copyrc,pc1,pc2,pc3);

      repeat Assign(dati,'I.DAT'); Reset(dati); i:=0;
             for iZ:=1 to iZ1 do Readln(dati);
             while (not Eof(dati)) and (i<wanz) do
             begin i:=i+1; Readln(dati,auswahl[i].t); end;
             for iP:=1 to wanz do begin auswahl[iP].x:=5; auswahl[iP].y:=5+iP; end;
             auswahl[i+1].x:= 5; auswahl[i+1].y:=7+wanz; auswahl[i+1].t:='weiter blÑttern';
             auswahl[i+2].x:=45; auswahl[i+2].y:=7+wanz; auswahl[i+2].t:='zurÅck blÑttern';
             Window( 2, 6,79,7+wanz); clrscr; Window( 1, 1,80,25);
             w:=i+1; wahl1(i+2);
             if (w=i+1) and not Eof(dati)
                then                        iZ1:=iZ1+7
                else if (w=i+2) and (iZ1>7)
                        then                iZ1:=iZ1-7
                        else if w=i+2 then  iZ1:=0;
      until (w<>i+1) and (w<>i+2);

      iP:=pos(',',auswahl[w].t);
      par3:=copy(auswahl[w].t,iP+1,length(auswahl[w].t)-iP);

      Assign(dato,'INSTALL.DAT'); Rewrite(dato);
      Writeln(dato,'(c) ',datum.Tag:2,'.',datum.Monat:2,'.',datum.Jahr:2,' by  NILES-SOFT');
      Writeln(dato,'               for '+par3);

      Writeln(dato,'                   NILES-DOS Version 2.2 (reduziert)');
      Writeln(dato,'#');
      Writeln(dato,copy(auswahl[w].t,1,14));

      Assign(dati,'INSTALL'); Reset(dati);
      while not Eof(dati) do
      begin Readln(dati,hilf); Writeln(dato,hilf); end;
      Close(dati); Close(dato);

      c1_write(1,1,'');
      Window( 1, 1,80,25); clrscr; halt(0);
end.
