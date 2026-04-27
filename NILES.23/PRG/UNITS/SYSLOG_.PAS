{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit SysLog_;

interface

     uses dos,crt;

     type   SysLog = record proj    : array[1.. 8] of char;
                            bea     : array[1.. 5] of char;
                            dwg     : array[1.. 8] of char;
                            dat     : array[1.. 8] of char;
                            tims    : array[1.. 4] of char;
                            time    : array[1.. 4] of char;
                            min     : array[1.. 4] of char;
                            sk      : array[1.. 2] of char;
                     end;

     var    SysLog_d                : file   of SysLog;
            SysLog_p                :           SysLog;
            SysLog_exit             :           Boolean;

     procedure SysLog_O;
     procedure SysLog_R;
     procedure SysLog_W;
     procedure SysLog_C;

implementation

     procedure SysLog_O;
     begin Assign  (SysLog_d,'E:\SYSLOG\LOGMASCH.DAT');
           SetFAttr(SysLog_d,Archive);
           Reset   (SysLog_d);
           if (IOResult<>0) or (FileSize(SysLog_d)=0) then SysLog_exit:=false
                                                      else SysLog_exit:=true;
     end;

     procedure SysLog_R;
     begin Read(SysLog_d,SysLog_p);
     end;

     procedure SysLog_W;
     begin Write(SysLog_d,SysLog_p);
     end;

     procedure SysLog_C;
     begin Close   (SysLog_d);
           SetFAttr(SysLog_d,Archive+ReadOnly+Hidden+SysFile);
     end;

end.
