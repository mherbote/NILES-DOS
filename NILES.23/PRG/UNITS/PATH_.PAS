{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Path_;

interface

     uses dos,crt,crt_;

     type   path_type       =                    String[30];
            bezeichnung     =                    Array[1..39] of char;
            path            = record nam       : array[1.. 8] of char;
                                     ext       : array[1.. 3] of char;
                                     path      : array[1..30] of char;
                                     bezeich   :                 bezeichnung;
                                     cr,lf     :                 char;
                              end;

     var    path_d          : file   of path;
            path_p          :           path;
            path_exit       :           Boolean;

     procedure path_OC;
     procedure path_O;
     procedure path_R;
     procedure path_W;
     procedure path_C;
     procedure p_text_s(var path:path_type; search:bezeichnung);

implementation

     procedure path_OC;
     begin Assign  (path_d,'C:\PATH.TXT'); SetFAttr(path_d,Archive);
           Reset   (path_d);
           if (IOResult<>0) or (FileSize(path_d)<3) then path_exit:=false
                                                    else path_exit:=true;
     end;

     procedure path_O;
     begin path_OC;
           if not path_exit
              then begin c4_write(10,20,'Die Datei  "PATH.TXT"  ist nicht ');
                         c4_write(11,20,'      e x i s t e n t !!!        ');
                         halt(1);
                   end;
     end;

     procedure path_R;
     begin Read(path_d,path_p);  end;

     procedure path_W;
     begin Write(path_d,path_p); end;

     procedure path_C;
     begin Close   (path_d);
           SetFAttr(path_d,Archive+ReadOnly+Hidden+SysFile);
     end;

     procedure p_text_s(var path:path_type; search:bezeichnung);
     begin Seek(path_d,0); repeat path_R;
                           until (path_p.bezeich=search) or Eof(path_d);
           if path_p.bezeich=search
           then begin path:=path_p.path; path[0]:=chr(1);
                      while path[ord(path[0])+1]<>' ' do path[0]:=chr(ord(path[0])+1);
                end
           else begin c4_write(10,20,'Die Datei  "PATH.TXT"  enth„lt keinen');
                      c4_write(11,20,'Eintrag: "'+search+'" !!!');
                      halt(1);
                end;
     end;

end.
