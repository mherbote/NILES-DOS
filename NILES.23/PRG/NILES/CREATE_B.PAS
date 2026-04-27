{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 5500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{********************************************
 * CREATE_B.PAS                             *
 * BATCH.BAT erstellen                      *
 *                                          *
 *         (c) by NILES-SOFT 1988 VERS. 2.3 *
 *            Programmierer: Marcus Herbote *
 ********************************************}

uses   dos,crt,crt_,Batch_,Mount_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     C R E A T E _ B';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

var    c,k                         : string[1];
       ch                          : char;
       x,y,p                       : integer;

procedure open_bat(id:integer);
begin Mount_Log;
      case id of
      0,1: begin assign(ip[1],'C:\CONFIG.SYS'   ); reset(ip[1]); end;
        2: begin assign(ip[1],path_bat2+ nam    ); reset(ip[1]); end;
        3: begin assign(ip[1],path_bat2+'WURZEL'); reset(ip[1]); end;
        4: begin assign(ip[1],path_bat2+ nam    ); reset(ip[1]); end;
      end;
      if id<>4
      then begin case id of
                 0,1:       assign(out,path_bat1+'BATCH.BAT');
                 else begin assign(out,path_bat2+'BATCH.BAK');
                            erase (out); i:=IOResult;
                            assign(out,path_bat2+'BATCH.BAT');
                            rename(out,path_bat2+'BATCH.BAK'); i:=IOResult;
                            assign(out,path_bat2+'BATCH.BAT');
                      end;
                 end;
                 rewrite(out);
                 writeln(out,'ECHO    off'); writeln(out,'BREAK   off');
                 writeln(out,'CLS        ');
                 writeln(out, s_env1      ); writeln(out, s_env2      );
                 writeln(out, s_env3      ); writeln(out, s_env4      );
           end;
end;

procedure close_bat;
begin write(out,#26); close(out  ); close(ip[1]); Demount_Log; end;


begin assign(ip[1],path_bat2+'WURZEL');
      reset(ip[1]); s_env2:=''; readln(ip[1],s_env2);
                    s_env3:=''; readln(ip[1],s_env3);
      close(ip[1]);

      nam:=paramstr(1); c:=paramstr(2); k:=paramstr(3);
      val(paramstr(4),x,p); val(paramstr(5),y,p);
{$IFDEF Debug} clrscr; writeln(nam,',',c,',',k,',',x,',',y); {$ENDIF}
      case c[1] of
      'b': begin open_bat(3); weiter:=true;
             repeat ini(1); until (cop[1][2]=k) or (eof(ip[1]));
             if not eof(ip[1])
             then repeat ini(1);
                         if cop[1][1]='>'
                         then begin for i:=2 to length(cop[1]) do
                                        begin write(out,cop[1][i]); end;
                                    writeln(out); weiter:=false;
                              end;
                  until (cop[1][1]<>'>') or (eof(ip[1]));
             if weiter then
                begin open_bat(4);
                      repeat ini(1); until (cop[1][2]=k) or (eof(ip[1]));
                      repeat ini(1);
                             if cop[1][1]='>'
                             then begin for i:=2 to length(cop[1]) do
                                            begin write(out,cop[1][i]); end;
                                        writeln(out);
                                  end;
                      until (cop[1][1]<>'>') or (eof(ip[1]));
                end;
             close_bat;
           end;
      'l': begin ch:=' ';
                 repeat gotoxy(x- 4,y); write('    Laufwerk:                       ');
                        gotoxy(x+10,y); ch:=readkey; write(ch);
                        if ch in ['A'..'Z'] then ch:=chr(ord(ch)+ord(' '));
                 until ch in ['d'..'z'];
                 open_bat(2); writeln(out,'mount '+ch+':');
                              writeln(out,'IF errorlevel 1 goto End');
                              writeln(out,ch+':');
                              writeln(out,':End');
                 close_bat;
           end;
      '~': begin open_bat(2);
                 repeat formal:='';
                        gotoxy(x-4,y); write('>                                   ');
                        gotoxy(x-3,y); readln(formal);
                        if length(formal)>0 then writeln(out,formal);
                 until length(formal)=0;
                 close_bat;
           end;
      end;
end.
