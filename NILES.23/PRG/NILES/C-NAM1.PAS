{$A-,B-,D+,E+,F-,I+,L+,N-,O-,R-,S+,V+}
{$M 16384,0,0}
{$DEFINE Debug}

uses crt,dos,Lognam1_;

var i,j,k,l,anz    : Integer;



begin ClrScr;
      LogNam1_O(anz);
      for i:=1 to  20 do
          if LogNam1_p.pw[i]<>'ê' then Writeln(chr(ord('F')+i),':',LogNam1_p.pw[i]);
      Writeln;
      for i:=1 to anz do Writeln(LogNam1_p.bkz[i],':',LogNam1_p.lwl[i]);
end.
*)
begin ClrScr;
      for i:=1 to 20 do LogNam1_p.pw[i]:='ê';
{G}   LogNam1_p.pw[1]:='tp6-wbs70 gê';
{H}   LogNam1_p.pw[2]:='msh-pr…œê';

      LogNam1_p.bkz[ 1]:='SYSTE'; LogNam1_p.lwl[ 1]:='                    ';
      LogNam1_p.bkz[ 2]:='ELiTE'; LogNam1_p.lwl[ 2]:='                    ';
      LogNam1_p.bkz[ 3]:='COOPS'; LogNam1_p.lwl[ 3]:='                    ';
      LogNam1_p.bkz[ 4]:='DBANK'; LogNam1_p.lwl[ 4]:='                    ';
      LogNam1_p.bkz[ 5]:='VENTU'; LogNam1_p.lwl[ 5]:='                    ';

      LogNam1_p.bkz[ 6]:='GUSKE'; LogNam1_p.lwl[ 6]:='G                   ';
      LogNam1_p.bkz[ 7]:='msh-1'; LogNam1_p.lwl[ 7]:='GH                  ';
      LogNam1_C(7);
end.
begin ClrScr;
      for i:=1 to 20 do LogNam1_p.pw[i]:='ê';
{G}   LogNam1_p.pw[1]:='tp6-œÕ386-f/4gê';
{H}   LogNam1_p.pw[2]:='tp6-œÕ386-f/4hê';
{I}   LogNam1_p.pw[3]:='tp6-œÕ386-f/4iê';
{J}   LogNam1_p.pw[4]:='tp6-œÕ386-f/4jê';
{K}   LogNam1_p.pw[5]:='tp6-œÕ386-f/4kê';
{L}   LogNam1_p.pw[6]:='tp6-œÕ386-f/4lê';

      LogNam1_p.bkz[ 1]:='SYSTE'; LogNam1_p.lwl[ 1]:='                    ';
      LogNam1_p.bkz[ 2]:='ELiTE'; LogNam1_p.lwl[ 2]:='                    ';
      LogNam1_p.bkz[ 3]:='COOPS'; LogNam1_p.lwl[ 3]:='                    ';
      LogNam1_p.bkz[ 4]:='DBANK'; LogNam1_p.lwl[ 4]:='                    ';
      LogNam1_p.bkz[ 5]:='VENTU'; LogNam1_p.lwl[ 5]:='                    ';
      LogNam1_p.bkz[ 6]:='GUSKE'; LogNam1_p.lwl[ 6]:='GL                  ';
      LogNam1_p.bkz[ 7]:='SCHLE'; LogNam1_p.lwl[ 7]:='H                   ';
      LogNam1_p.bkz[ 8]:='WINKL'; LogNam1_p.lwl[ 8]:='I                   ';
      LogNam1_p.bkz[ 9]:='REICH'; LogNam1_p.lwl[ 9]:='J                   ';
      LogNam1_p.bkz[10]:='msh-1'; LogNam1_p.lwl[10]:='GHIJKL              ';
      LogNam1_p.bkz[11]:='WBS-1'; LogNam1_p.lwl[11]:='L                   ';
      LogNam1_p.bkz[12]:='WBS-2'; LogNam1_p.lwl[12]:='L                   ';
      LogNam1_C(12);
end.
