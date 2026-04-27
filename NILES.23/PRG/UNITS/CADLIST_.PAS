{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Cadlist_;

interface

     uses dos,crt;

     type   cadlist     = record kz       : char;
                                 dat      : record case kz : char of
                                                   '1': (ort     : array[1..13] of char;
                                                         gebiet  : array[1..13] of char;
                                                         fuell1  : array[1.. 9] of char;
                                                         objekt  : array[1..13] of char;
                                                         fuell2  : array[1..22] of char;
                                                         objnr   : array[1..11] of char;
                                                         typ     : array[1.. 3] of char;
                                                         archdt  : array[1..12] of char;
                                                         bib1    : array[1.. 8] of char;
                                                         bib2    : array[1.. 3] of char;
                                                         archneu : array[1..12] of char;
                                                         bibn1   : array[1.. 8] of char;
                                                         bibn2   : array[1.. 3] of char;
                                                         fuell3  : array[1.. 3] of char);
                                                   '2': (eser_nr : array[1.. 7] of char;
                                                         znr_alt : array[1.. 8] of char;
                                                         znr_neu : array[1.. 8] of char;
                                                         zdatanf : array[1.. 8] of char;
                                                         name    : array[1..22] of char;
                                                         fuell4  : array[1..13] of char;
                                                         maszst  : array[1.. 6] of char;
                                                         format  : array[1.. 2] of char;
                                                         reflst  : array[1..14] of char;
                                                         fuell5  : array[1..44] of char);
                                                   end;
                                            end;

     var    cadl_d      : file of cadlist;
            cadl_p      :         cadlist;
            cadl_exit   :         Boolean;

     procedure cadl_O(path,typ:String);
     procedure cadl_R;
     procedure cadl_W;
     procedure cadl_C;

implementation

     procedure cadl_O(path,typ:String);
     begin Assign  (cadl_d,path+typ); SetFAttr(cadl_d,Archive);
           Reset   (cadl_d);
           if (IOResult<>0) or (FileSize(cadl_d)<3) then cadl_exit:=false
                                                    else cadl_exit:=true;
     end;

     procedure cadl_R; begin Read(cadl_d,cadl_p);  end;

     procedure cadl_W; begin Write(cadl_d,cadl_p); end;

     procedure cadl_C; begin Close   (cadl_d);     end;

end.
