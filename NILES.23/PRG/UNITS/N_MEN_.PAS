{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit N_Men_;

interface

     uses dos,crt,Mount_,SysHalt_;

var  Men_Nr,Men_Nrh   :                 Integer;
     Men_Nr_c,Men_h   :                 String[4];
     ComSpec,hilf_p   :                 String;
     S_Rec            :                 SearchRec;
     c1,c2            :                 Text;
     gef              :                 Boolean;

     procedure Sys_Halt(id:Integer);
     procedure Men_konv;
     procedure Men_red   (path             :String; Men__Nr,Z_Nr   :Integer);
     function  Men_compr (path             :String; Men__Nr,mv     :Integer):Boolean;
     procedure MenZ_compr(path             :String; Men__Nr,m1     :Integer);
     procedure Men_g_red (path,acad,ak1,ak2:String; Men__Nr,m1,par3:Integer);

implementation

procedure Sys_Halt(id:Integer);
begin Demount_Log; Sys_halt1(id); halt(id); end;

procedure Men_konv;
  var i:integer;
begin Str(Men_Nr:4,Men_Nr_c);
      for i:=1 to 4 do if Men_Nr_c[i]=' ' then Men_Nr_c[i]:='0';
end;

procedure Men_red(path:String; Men__Nr,Z_Nr:Integer);
  var mcv,mca,mcn:String[4];
      i          :Integer;
begin Men_Nr:=Men__Nr; Men_konv;
      Assign(c1,path+Men_Nr_c); Rename(c1,path+Men_Nr_c+'.BAK'); Reset  (c1);
      Assign(c2,path+Men_Nr_c);                                  Rewrite(c2);
      Readln(c1,hilf_p);
      while hilf_p[1]<>'b' do
      begin Writeln(c2,hilf_p); Readln(c1,hilf_p); end;
      for i:=1 to Z_Nr-1 do begin repeat Writeln(c2,hilf_p);
                                         Readln (c1,hilf_p);
                                  until hilf_p[1]<>'>';
                         end;
      repeat Readln(c1,hilf_p); until hilf_p[1]<>'>';
      while not Eof(c1) do
      begin Writeln(c2,hilf_p); Readln(c1,hilf_p); end;
      Writeln(c2,hilf_p); Close(c1); Close(c2); Erase(c1);
end;

function Men_compr(path:String; Men__Nr,mv:Integer):Boolean;
  var mcv,mca,mcn:String[4];
  Label M1;
begin               Men_Nr:=Men__Nr; Men_konv; Men_compr:=FALSE;
{ Test, ob leer }   Assign(c1,path+Men_Nr_c); Reset(c1); gef:=FALSE;
                    while not Eof(c1) and not gef do
                    begin if hilf_p[1]='b' then gef:=TRUE; Readln(c1,hilf_p); end;
                    Close(c1);
                    if not gef
                    then begin
{ dann lîschen }               Erase(c1); Men_compr:=TRUE;
                               if Men__Nr-(Men__Nr div 100)*100>0 then gef:=TRUE else gef:=FALSE;
{  und aufrÅcken }             repeat mca:=Men_Nr_c;
                                      Dec(Men_Nr  ); Men_konv; mcv:=Men_Nr_c;
                                      Inc(Men_Nr,2); Men_konv; mcn:=Men_Nr_c;
                                      FindFirst(path+mcn,AnyFile,S_Rec); if DosError<>0 then mcn:='';
                                      if mcn='' then Goto M1; gef:=FALSE;
                                      Assign(c1,path+mcn); Reset  (c1);
                                      Assign(c2,path+mca); Rewrite(c2);
                                      while not Eof(c1) do
                                      begin Readln(c1,hilf_p);
                                            if copy(hilf_p,1,3)='m1,'
                                               then begin Delete(hilf_p,10,4); Insert(mcv,hilf_p,10); end;
                                            if copy(hilf_p,1,3)='m2,'
                                               then begin Delete(hilf_p,10,4); Insert(mcn,hilf_p,10); end;
                                            if not (((Men_Nr-(Men_Nr div 100)*100)-1=0) and (copy(hilf_p,1,3)='m1,'))
                                               then Writeln(c2,hilf_p);
                                      end;
                                      Close(c1); Close(c2); Erase(c1);
M1:                            until mcn=''; Dec(Men_Nr); Men_konv;
                               if gef then begin Assign(c1,path+mcv); Rename(c1,path+mcv+'.BAK'); Reset  (c1);
                                                 Assign(c2,path+mcv);                             Rewrite(c2);
                                                 while not Eof(c1) do
                                                 begin Readln(c1,hilf_p);
                                                       if copy(hilf_p,1,3)<>'m2,' then Writeln(c2,hilf_p);
                                                 end;
                                                 Close(c1); Close(c2); Erase(c1);
                                           end;
                         end;
end;

procedure MenZ_compr(path:String; Men__Nr,m1:Integer);
  var mcv,mca,mcn:String[4];
      ma,mn,i    :Integer;
  Label E1;
begin                  ma:=Men__Nr; gef:=FALSE;
{ TIT"m2" verdichten } repeat             Men_Nr:=ma; Men_konv; mca:=Men_Nr_c;
                              mn:=ma+100; Men_Nr:=mn; Men_konv; mcn:=Men_Nr_c;
                              FindFirst(path+'TIT'+mcn,AnyFile,S_Rec);
                              if DosError=0
                              then begin Exec(ComSpec,'/C RENAME '+path+'TIT'+mcn+' TIT'+mca);
{ "m2"    verdichten }                   i:=ma; FindFirst(path+mcn,AnyFile,S_Rec);
                                         while DosError=0 do
                                         begin            Men_Nr:=i ; Men_konv; mca:=Men_Nr_c;
                                               mn:=i+100; Men_Nr:=mn; Men_konv; mcn:=Men_Nr_c;
                                               Assign(c1,path+mcn); Reset  (c1);
                                               Assign(c2,path+mca); Rewrite(c2);
                                               while not Eof(c1) do
                                               begin Readln(c1,hilf_p);
                                                     if copy(hilf_p,1,6)='E ,TIT'
                                                        then begin Delete(hilf_p,7,2);
                                                                   Insert(copy(mca,1,2),hilf_p,7);
                                                             end;
                                                     if (copy(hilf_p,1,3)='m1,') or (copy(hilf_p,1,3)='m2,')
                                                        then begin Delete(hilf_p,10,2);
                                                                   Insert(copy(mca,1,2),hilf_p,10);
                                                             end;
                                                     Writeln(c2,hilf_p);
                                               end;
                                               Close(c1); Close(c2); Erase(c1);
                                               Inc(i); Men_Nr:=i; Men_konv;
                                               FindFirst(path+Men_Nr_c,AnyFile,S_Rec);
                                         end;
                                   end
                              else gef:=TRUE;
                              Inc(ma,100);
                       until gef;
{ "m1" aktualisieren } ma:=Men__Nr; i:=m1-1; gef:=FALSE; Men_Nr:=ma; Men_konv; mca:=Men_Nr_c;
                       mn:=ma+100;                       Men_Nr:=mn; Men_konv; mcn:=Men_Nr_c;
                       repeat Inc(i); Men_Nr:=i; Men_konv; Assign(c1,path+Men_Nr_c); Reset(c1);
                              if (IOResult<>0) and (Men__Nr-(Men__Nr div 100)*100=0) then Goto E1;
                              if  IOResult<>0 then Sys_Halt(20);
                              while not (Eof(c1) or gef) do
                              begin Readln(c1,hilf_p);
                                    if copy(hilf_p,10,4)=mcn then gef:=TRUE;
                              end;
                              Close(c1);
                       until gef; gef:=FALSE;
                       repeat Assign(c1,path+Men_Nr_c); Rename(c1,path+Men_Nr_c+'.BAK'); Reset  (c1);
                              Assign(c2,path+Men_Nr_c);                                  Rewrite(c2);
                              while not Eof(c1) do
                              begin Readln(c1,hilf_p);
                                    if copy(hilf_p,10,4)=mcn
                                       then begin Delete(hilf_p,10,2); Insert(copy(mca,1,2),hilf_p,10);
                                                  Inc(ma,100); Men_Nr:=ma; Men_konv; mca:=Men_Nr_c;
                                                  Inc(mn,100); Men_Nr:=mn; Men_konv; mcn:=Men_Nr_c;
                                            end;
                                    Writeln(c2,hilf_p);
                              end;
                              Close(c1); Close(c2); Erase(c1);
                              Inc(i); Men_Nr:=i; Men_konv; FindFirst(path+Men_Nr_c,AnyFile,S_Rec);
                       until DosError<>0;
E1:
end;

procedure Men_g_red (path,acad,ak1,ak2:String; Men__Nr,m1,par3:Integer);
  procedure del_acad;                                         { . keine "m1"-er mehr, }
  begin Assign(c1,path+acad+'_ACAD.BAT'); Erase(c1);          { . dann "_ACAD.BAT"    }
        Assign(c1,path+'0000'); Rename(c1,path+'0000.BAK');   { . und in 0000 lîschen }
                                Reset (c1);
        Assign(c2,path+'0000'); Rewrite(c2);
        while not Eof(c1) do
        begin Readln(c1,hilf_p);
              case par3 of
                0: if copy(hilf_p,1,2)=ak1
                      then while copy(hilf_p,1,2)<>ak2 do Readln (c1,hilf_p)
                      else                                Writeln(c2,hilf_p);
                1: if copy(hilf_p,1,2)<>ak1 then Writeln(c2,hilf_p);
              end;
        end;
        Write(c2,'.'); Close(c1); Close(c2); Erase(c1);
  end;
begin Men_Nr:=m1-1; gef:=FALSE;              { . hîchstes "m1"-er MenÅ suchen }
      repeat Inc(Men_Nr); Men_konv;
             FindFirst(path+Men_Nr_c,AnyFile,S_Rec);
      until DosError=18;
      if Men_Nr=m1
      then       del_acad
      else begin { . Test, ob leer und wenn ja, dann lîschen }
                 repeat Dec(Men_Nr); Men_konv;
                        Assign(c1,path+Men_Nr_c); Reset(c1);
                        Readln(c1,hilf_p); Readln(c1,hilf_p); { .. Color und Titel öberl. }
                        Readln(c1,hilf_p);
                        if hilf_p[2] in ['z','1']
                        then begin Close(c1); Erase(c1);
                                   if Men_Nr>m1
                                   then begin Dec(Men_Nr); Men_konv;
                                              Assign(c1,path+Men_Nr_c); Rename(c1,path+Men_Nr_c+'.BAK');
                                                                        Reset  (c1);
                                              Assign(c2,path+Men_Nr_c); Rewrite(c2);
                                              while not Eof(c1) do
                                              begin Readln(c1,hilf_p);
                                                    if hilf_p[2]<>'2' then Writeln(c2,hilf_p);
                                              end;
                                              Close(c1); Close(c2); Erase(c1);
                                              Inc(Men_Nr); Men_konv;
                                        end;
                             end
                        else gef:=TRUE;
                 until (Men_Nr=m1) or gef;
                 if not gef then del_acad;
           end;
      Assign(c1,path+'0000'); Reset(c1);                          { . wenn 0000 leer, lî. }
      Readln(c1,hilf_p); Readln(c1,hilf_p);                       { .. Color und Titel Åberl.}
      Readln(c1,hilf_p); Close(c1);
      if hilf_p[1]='.' then begin Erase(c1); Assign(c1,path+'WURZEL'); Erase(c1);
                                  RmDir(copy(path,1,Length(path)-1));
                            end;
end;


begin ComSpec:=GetEnv('COMSPEC');
end.
