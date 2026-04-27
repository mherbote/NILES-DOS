{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit LogNam1_;

interface

     uses dos,crt,Mount_;

     type   LogNam1         = record pw  : Array[1.. 20] of String[20];
                                     bkz : Array[1..100] of String[ 5];
                                     lwl : Array[1..100] of String[20];
                              end;

     var    LogNam1_d       : File   of Char;
            LogNam1_p       :           LogNam1;
            LogNam1_exit    :           Boolean;

     procedure LogNam1_O(var anz:Integer);
     procedure LogNam1_C(    anz:Integer);
     procedure LogNam1_L;

implementation

     const byt2=$A5;

     var   i,j,byt1        :           Integer;
           bbb             :           Char;

     procedure LogNam1_O(var anz:Integer);
       procedure rrr;
       begin Read(LogNam1_d,bbb); bbb:=chr(ord(bbb)-i+byt1); byt1:=byt1+2*i+i; end;
     begin Mount_Log;
           Assign(LogNam1_d,'E:\SYSLOG\LOGNAM1.DAT'); SetFAttr(LogNam1_d,Archive);
           Reset(LogNam1_d); byt1:=byt2;
           for j:=1 to 20 do LogNam1_p.pw[j]:=''; i:=1; j:=1;
           if (IOResult<>0) or (FileSize(LogNam1_d)<3) then LogNam1_exit:=false
                                                       else LogNam1_exit:=true;
           if LogNam1_exit
              then begin for j:=1 to 20 do
                             begin repeat rrr;
                                          LogNam1_p.pw[j]:=LogNam1_p.pw[j]+bbb;
                                          i:=i+1;
                                   until bbb='ê';
                                   i:=1;
                             end;
                         j:=1;
                         repeat rrr;
                                if bbb<>'#' then
                                   begin LogNam1_p.bkz[j]:=bbb+'    ';
                                         for i:=2 to  5 do
                                             begin rrr; LogNam1_p.bkz[j][i]:=bbb; end;
                                         LogNam1_p.lwl[j]:='';
                                         for i:=1 to 20 do
                                             begin rrr;
                                                   LogNam1_p.lwl[j]:=LogNam1_p.lwl[j]+bbb;
                                             end;
                                         j:=j+1; i:=1;
                                   end;
                         until bbb='#';
                   end;
           Close(LogNam1_d); SetFAttr(LogNam1_d,Archive+ReadOnly+Hidden+SysFile);
           Demount_Log; anz:=j-1;
     end;

     procedure LogNam1_C(anz:Integer);
       procedure www;
       begin bbb:=chr(ord(bbb)+i-byt1); Write(LogNam1_d,bbb); byt1:=byt1+2*i+i; end;
     begin Mount_Log;
           Assign(LogNam1_d,'E:\SYSLOG\LOGNAM1.DAT'); SetFAttr(LogNam1_d,Archive);
           Rewrite(LogNam1_d); byt1:=byt2;
           i:=1; j:=1;
           for j:=1 to 20 do
               begin repeat bbb:=LogNam1_p.pw[j][i]; www; i:=i+1;
                     until LogNam1_p.pw[j][i-1]='ê';
                     i:=1;
               end;
           for j:=1 to anz do
               begin for i:=1 to  5 do
                         begin bbb:=LogNam1_p.bkz[j][i]; www; end;
                     for i:=1 to 20 do
                         begin bbb:=LogNam1_p.lwl[j][i]; www; end;
               end;
           i:=1; bbb:='#'; www;
           Close   (LogNam1_d); SetFAttr(LogNam1_d,Archive+ReadOnly+Hidden+SysFile);
           Demount_Log; LogNam1_L;
     end;

     procedure LogNam1_L;
     begin for i:=1 to  20 do for j:=1 to 20 do LogNam1_p.pw [i][j]:=' ';
           for i:=1 to 100 do for j:=1 to  5 do LogNam1_p.bkz[i][j]:=' ';
           for i:=1 to 100 do for j:=1 to 20 do LogNam1_p.lwl[i][j]:=' ';
     end;

end.
