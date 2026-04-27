{$R-,S-,I-,D-,F-,V+,B+,N-,L+ }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{********************************************
 * CHANGE_B.PAS                             *
 * externe Include's von BATCH.BAT aufl”sen *
 *                                          *
 *         (c) by NILES-SOFT 1988 VERS. 2.3 *
 *            Programmierer: Marcus Herbote *
 ********************************************}

uses   dos,crt,crt_,Fenster_,Batch_,Mount_;

const  copyrc                      = '(c) 88,89 by NILES-SOFT';
       pc1                         = 'M o d u l :     C H A N G E _ B';
       pc2                         = 'V e r s i o n   2  .  3';
       pc3                         = '11.04.89';

var wei : boolean;

procedure string_input;
  var ap,fp,i : integer;
      as,fs   : string[70];
begin ap:=pos('(',cop[1]); fp:=pos('(',formal);
      if (formal[fp+1]<>')') and (cop[1][ap+1]<>')')
      then repeat as:=''; repeat ap:=ap+1; as:=as+cop[1][ap];
                          until (cop[1][ap]=')') or (cop[1][ap]=',');
                  fs:=''; repeat fp:=fp+1; fs:=fs+formal[fp];
                          until (formal[fp]=')') or (formal[fp]=',');
                  delete(as,length(as),1); delete(fs,length(fs),1);
                  repeat i:=pos(fs,cop[2]);
                         if i<>0 then
                            begin delete(cop[2],i,length(fs));
                                  insert(as,cop[2],i);
                            end;
                  until i=0;
           until (formal[fp]=')') or (cop[1][ap]=')');
end;

procedure change_bat(id:integer);
begin assign(ip[1],path_bat2+'BATCH.BAT'); reset  (ip[1]);
      assign(out  ,path_bat2+'$$$$$.BAT'); rewrite(out  );
      repeat ini(1);
             if (cop[1][1]='$') and not ((id=1) and (cop[1][2]='"'))
                then begin case id of
                             1: assign(ip[2],path_bat2+nam);
                             2: begin i:=pos('"',cop[1]); cop[2]:='';
                                      repeat i:=i+1; cop[2]:=cop[2]+cop[1][i];
                                      until cop[1][i+1]='"';
                                      assign(ip[2],path_bat2+cop[2]); reset(ip[2]);
                                      if IOResult<>0 then assign(ip[2],path_bat2+'..\'+cop[2]);
                                      wei:=false;
                                end;
                           end;
                           reset(ip[2]); weiter:=false;
                           case id of
                             1: repeat ini(2);
                                       for i:=1 to 3 do
                                           if cop[1][i]=cop[2][i] then weiter:=true;
                                until (weiter) or (eof(ip[2]));
                             2: ini(2);
                           end;
                           formal:=cop[2];
                           repeat ini(2); string_input;
                                  for i:=2 to length(cop[2]) do write(out,cop[2][i]);
                                  writeln(out);
                           until (cop[2][1]<>'>') or (eof(ip[2]));
                           close(ip[2])
                     end
                else writeln(out,cop[1]);
      until eof(ip[1]);
      writeln(out,#26); close(ip[1]); close(out);
                        erase(ip[1]); rename(out,path_bat2+'BATCH.BAT');
end;


begin {$IFDEF Debug} CheckBreak:=true; {$ELSE} CheckBreak:=false; {$ENDIF}
      c1_write(1,1,''); nam:=paramstr(1);
      Mount_Log;
      change_bat(1);
      repeat wei:=true; change_bat(2); until wei;
      Demount_Log;
end.
