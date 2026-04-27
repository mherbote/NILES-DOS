{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1024,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{*******************************************
 * E-PATH.PAS                              *
 * Datei  C:\PATH.TXT  pflegen             *
 *                                         *
 *        (c) by NILES-SOFT 1988 VERS. 2.3 *
 *           Programmierer: Marcus Herbote *
 *******************************************}

uses   dos,crt,crt_,Fenster_,Batch_,Wahl_,Syshalt_,Mount_,Path_,IStr_;

const  copyrc           = '(c) 88,89 by NILES-SOFT';
       pc1              = 'M o d u l :     E  -  P  A  T  H';
       pc2              = 'V e r s i o n   2  .  3';
       pc3              = '01.11.89';

var    i,von,bis            : Integer;
       x                    : LongInt;
       nam,ext,path,bezeich : String[255];


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
      then clrscr
      else begin Window( 9, 7,70,21); clrscr; Window(1,1,80,25); end;
      fenster(1, 9, 7,70,16,'É','Í','»','º','È','¼','º','Í',copyrc,pc1,pc2,pc3);

      path_O; path_p.cr:=#13; path_p.lf:=#10; w:=6;

      if not path_exit then
         begin with path_p do
                    begin nam    :='        ';
                          ext    :='   ';
                          path   :='                              ';
                          bezeich:='                                       ';
                    end;
               Rewrite(path_d); path_W; path_C; path_O;
         end;
      Seek(path_d,0); path_R;
      repeat c1_write(23, 1,''); clreol; c1_write(24, 1,''); clreol;
             Window(10,12,69,15); clrscr; Window( 1, 1,80,25);
             c1_write(11,11,'Bezeichnung: '); c2_write(11,24,path_p.bezeich);
             c1_write(13,11,'Pfad       : '); c2_write(13,24,path_p.path);
             c1_write(14,11,'Dateiname  : '); c2_write(14,24,path_p.nam+'.'+path_p.ext);
             c1_write(15,55,'Satz: '); write(FilePos(path_d):5);
             auswahl[1].x:= 3; auswahl[1].y:=23; auswahl[1].t:='n„chsten Eintrag';
             auswahl[2].x:= 3; auswahl[2].y:=24; auswahl[2].t:='vorigen  Eintrag';
             auswahl[3].x:=25; auswahl[3].y:=23; auswahl[3].t:='Eintrag l”schen';
             auswahl[4].x:=25; auswahl[4].y:=24; auswahl[4].t:='Eintrag  „ndern';
             auswahl[5].x:=44; auswahl[5].y:=24; auswahl[5].t:='neuen Eintrag';
             auswahl[6].x:=63; auswahl[6].y:=24; auswahl[6].t:='Programm beenden';
             wahl1(6);
             gotoxy(1,23); clreol; gotoxy(1,24); clreol; c2_write(15,55,'');
             case w of
               1: if not Eof(path_d)   then path_R;
               2: if FilePos(path_d)>1 then
                     begin Seek(path_d,FilePos(path_d)-2); path_R;
                     end;
               3: begin write('Eintrag l”schen');
                        von:=FilePos(path_d); bis:=FileSize(path_d)-1;
                        for i:=von to bis do
                            begin Seek(path_d,i  ); path_R;
                                  Seek(path_d,i-1); path_W;
                            end;
                        with path_p do
                             begin nam    :='        ';
                                   ext    :='   ';
                                   path   :='                              ';
                                   bezeich:='                                       ';
                             end;
                        Seek(path_d,bis); path_W; path_C;
                        path_O; Seek(path_d,von); path_R;
                  end;
             4,5: begin nam    :='        ';
                        ext    :='   ';
                        path   :='                              ';
                        bezeich:='                                       ';
                        case w of
                          4: begin write('Eintrag „ndern'); von:=FilePos(path_d)-1;
                                   nam    :=path_p.nam;
                                   ext    :=path_p.ext;
                                   path   :=path_p.path;
                                   bezeich:=path_p.bezeich;
                             end;
                          5: begin write('neuen Eintrag '); von:=FileSize(path_d); end;
                        end; Seek(path_d,von); w:=6;
                        repeat c1_write(11,11,'Bezeichnung: '); c1_write(11,24,bezeich);
                               c1_write(13,11,'Pfad       : '); c1_write(13,24,path);
                               c1_write(14,11,'Dateiname  : ');
                               c1_write(14,24,nam+'.'+ext);
                               auswahl[1].x:= 3; auswahl[1].y:=24; auswahl[1].t:='Bezeichnung';
                               auswahl[2].x:=25; auswahl[2].y:=24; auswahl[2].t:='Pfad       ';
                               auswahl[3].x:=44; auswahl[3].y:=23; auswahl[3].t:='Dateiname  ';
                               auswahl[4].x:=44; auswahl[4].y:=24; auswahl[4].t:='Dateierwei.';
                               auswahl[5].x:=63; auswahl[5].y:=23; auswahl[5].t:='Speichern';
                               auswahl[6].x:=63; auswahl[6].y:=24; auswahl[6].t:='Abbruch  ';
                               wahl1(6);
                               gotoxy(1,23); clreol; gotoxy(1,24); clreol;
                               case w of
                                 1: bezeich:=IStr(bezeich,11,24);
                                 2: path   :=IStr(path   ,13,24);
                                 3: nam    :=IStr(nam    ,14,24);
                                 4: ext    :=IStr(ext    ,14,33);
                               end;
                        until w>4;
                        if w=5 then
                           begin move(nam[1],path_p.nam[1],8); move(path   [1],path_p.path   [1],30);
                                 move(ext[1],path_p.ext[1],3); move(bezeich[1],path_p.bezeich[1],39);
                                 path_W; path_C; path_O;
                           end;
                        Seek(path_d,von); path_R; w:=4;
                  end;
             end;
      until w=6;

      path_C; c1_write(1,1,'');
      if (ParamStr(1)='C') or (ParamStr(1)='c')
         then begin Window( 1, 1,80,25); clrscr;                    end
         else begin Window( 9, 7,70,21); clrscr; Window(1,1,80,25); end;
end.
