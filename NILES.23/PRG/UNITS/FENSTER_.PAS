{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Fenster_;

interface

     uses dos,crt;

     procedure fenster(id,x1,y1,x2,y2          : integer;
                       c1,c2,c3,c4,c5,c6,c7,c8 : char;
                       copyrc,pc1,pc2,pc3      : string  );

implementation

     procedure fenster(id,x1,y1,x2,y2          : integer;
                       c1,c2,c3,c4,c5,c6,c7,c8 : char;
                       copyrc,pc1,pc2,pc3      : string  );
        var i : integer;
     begin            gotoxy(x1,y1);                    write(c1);
           for i:=x1 to x2-2 do                         write(c2);
                                                        write(c3);
           for i:=y1+1 to y2-1 do
               begin  gotoxy(x1,i );                    write(c4);
                      gotoxy(x2,i );                    write(c7);
               end;
                      gotoxy(x1,y2);                    write(c5);
           for i:=x1 to x2-2 do                         write(c8);
                                                        write(c6);
           case id of
             0: ;
             1: begin gotoxy(x2-1-length(copyrc),y1+1); write(copyrc);
                      gotoxy(x1+2               ,y1+1); write(pc1   );
                      gotoxy(x1+2               ,y1+2); write(pc2   );
                      gotoxy(x2-1-length(pc3   ),y1+2); write(pc3   );
                end;
             2: begin gotoxy(x1+2               ,y1+2); write(copyrc);
                      gotoxy(x1+2               ,y1+1); write(pc1   );
                end;
           end;
     end;

end.
