{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Batch_;

interface

      uses dos,crt;

      type  str12           = string[80];
            str7            = string[ 7];

      const path_bat                              = 'BATCH\';
            path_bat1                             = 'C:\BAT\';
            s_env4                                = 'SET     prompt=$p$g';
            anz0                                  = 'FARBAUSWAHL: ';
            anz1            : array[1..2] of str7 = ('grund  ','auswahl');
            anz2            : array[1..2] of str7 = ('-hinten','-vorn  ');

      var   path_bat2       :                         str12;
            path_progr      :                         str12;
            s_env1,
            s_env2,s_env3   :                         string[255];
            formal          :                         string[255];

            ip              : array[1..  2       ] of text;
            out             :                         text;
            end1,end2,i     :                         integer;
            cop             : array[1..  2       ] of string[255];
            f_bild,mouse    :                         boolean;
            weiter,wei      :                         boolean;
            nam             :                         str12;
            cpos,w,zp,xp,yp :                         integer;
            drec            : array[1.. 50       ] of record c : char;
                                                             k : char;
                                                             y : integer;
                                                             x : integer;
                                                             a : string[ 4];
                                                             t : string[70];
                                                      end;
            reg             :                         registers;
            ch              :                         char;


            procedure ini       (id      : integer            )          ;
            function  cb        (id      : integer            ) : char   ;
            function  ib        (id      : integer            ) : integer;
            procedure i_out     (ii,z    : integer            )          ;


implementation


procedure ini(id:integer);
begin cop[id]:=''; readln(ip[id],cop[id]);
{      write(id,',',cop[id],',',cop[id][1]); readln;}
end;

function cb(id:integer):char;
begin cb:=cop[id][cpos];              {chr((ord(cop[id][cpos+0])-ord('0'))*100+
                                           (ord(cop[id][cpos+1])-ord('0'))* 10+
                                           (ord(cop[id][cpos+2])-ord('0')));}
      cpos:=cpos+2;                   {cpos:=cpos+4;}
end;

function ib(id:integer):integer;
begin ib:=((ord(cop[id,cpos+0])-ord('0'))*10+ord(cop[id][cpos+1])-ord('0'));
      cpos:=cpos+3;
end;

procedure i_out(ii,z:integer);
begin case z of
        3: {write(ip[2],(ii div 100),ii-(ii div 100)*100,',')};
        2: write(ip[2],(ii div 10),ii-(ii div 10)*10,',');
      end;
end;


begin

  reg.ax:=0; intr(51,reg);
  case reg.ax of
    0: begin mouse:=false; end;
  $FF: begin mouse:=true;
             reg.ax:=7; reg.cx:=0; reg.dx:=80*8; intr(51,reg);
             reg.ax:=8; reg.cx:=0; reg.dx:=25*8; intr(51,reg);
             reg.ax:=2;                          intr(51,reg);
       end;
  end;

  path_bat2:=path_bat1+path_bat;

  assign(ip[1],'C:\CONFIG.SYS'); weiter:=false;
  reset(ip[1]); repeat readln(ip[1],cop[1]);
                       if pos('shell',cop[1])<>0 then weiter:=true;
                until weiter;
  close(ip[1]);

  end1:=pos('MBATCH',cop[1]); end2:=pos('mbatch',cop[1]); i:=pos('=',cop[1]);
  if end2=0
     then path_progr:=copy(cop[1],i+1,end1-i-1)
     else path_progr:=copy(cop[1],i+1,end2-i-1);

  s_env1:='SET     comspec='+path_progr+'COMMAND.COM';

end.
