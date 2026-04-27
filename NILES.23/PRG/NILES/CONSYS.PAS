{$A-,B-,D-,E+,F-,I-,L-,N-,O-,R-,S-,V+}
{$M 16384,0,655360}
{$DEFINE Debug}
{$DEFINE Lib}
{$UNDEF  Debug}
{$UNDEF  Lib}
{$IFDEF Debug}
        {$D+,L+,S+}
{$ENDIF}

{******************************************************
 * CONSYS.PAS                                         *
 *                                                    *
 *                                                    *
 *                   (c) by NILES-SOFT 1989 VERS. 2.3 *
 *                      Programmierer: Marcus Herbote *
 ******************************************************}

uses EditZ_,dos,TPCrt,TPMenu,TPString;

const zaA                     =  4;
      zaE                     = 23;
      path                    = 'D:\UTILITYS\DRIVER\';
      Color1 : MenuColorArray = ($1F, $6E, $1B, $79, $1E, $1F);
      Color2 : MenuColorArray = ($0E, $0E, $0F, $78, $0C, $1F);
      Frame1 : FrameArray     = '…»ªºÕ∫';
      Frame2 : FrameArray     = 'À»ÀºÕ∫';
      copyrc                  = '(c) 89 by NILES-SOFT';
      pc1                     = 'Version 2.3';
      pc2                     = 'Modul: C O N S Y S';
      pc3                     = '24.10.89';

var men1                  :                 Menu;
    mk                    :                 MenuKey;
    Ch                    :                 Char;
    GD,GM                 :                 Integer;
    cs                    : Array[1..50] of String;
    csd                   :                 Text;
    csp                   :                 String;
    csa,csi,FILES,BUFFERS :                 Integer;
    S_Rec                 :                 SearchRec;

Label E31,E32,Ende;

procedure InitMenu1(var M : Menu);
begin {Customize this call for special exit characters and custom item displays}
      M := NewMenu([], nil);

      SubMenu(17,7,24,Vertical,Frame1,Color1,pc2+'          '+pc1);
      FindFirst(path+'*.CS',AnyFile,S_Rec); csi:=0;
      while DosError=0 do
      begin if S_Rec.Name<>'VAR.CS' then
               begin Assign(csd,path+S_Rec.Name); Reset(csd); Readln(csd,csp); Close(csd);
                     csi:=csi+1; csa:=pos('|',csp); if csa>0 then csp:=copy(csp,1,csa-1);
                     csa:=pos('"',csp); Delete(csp,csa,1);
                     MenuItem(csp,csi,csa,csi,'Bitte wÑhlen Sie Ihre Konfiguration aus');
               end;
            FindNext(S_Rec);
      end;
      csi:=csi+1;
      MenuItem('       variable           Konfiguration       ',csi,8,csi,
               'Bitte wÑhlen Sie Ihre Konfiguration aus');
      PopSublevel;
      ResetMenu(M);
end;

procedure InitMenu2(var M : Menu);
  var hd     : Text;
      hp,hp1 : String;
      mm,mp,z: Integer;
begin {Customize this call for special exit characters and custom item displays}
      M := NewMenu([], nil); Assign(hd,path+'VAR.CS'); Reset(hd); hp:=''; while hp<>'#' do Readln(hd,hp);

      SubMenu(25,1,24,Horizontal,Frame1,Color1,pc2+'          '+pc1);
      MenuItem('      éndern      ',35,7,3,'éndern von Parametern der ausgewÑhlten "CONFIG.SYS"');
         SubMenu(59,3,24,Vertical,Frame2,Color1,'');
         MenuItem('     FILES      ',1,6,31,'éndern der Anzahl gleichzeitig zu îffnender Dateien');
         MenuItem('    BUFFERS     ',2,5,32,'éndern der Anzahl von SystemPufferbereichen');
         MenuItem(' Neuen Treiber  ',3,2,33,'EinfÅgen eines neuen GerÑtetreibers');
         MenuItem('Edit einer Zeile',4,1,34,''); mm:=4;
         repeat Readln(hd,hp);
                if hp<>'#' then
                   begin Readln(hd,hp1); Inc(mm); mp:=pos('"',hp); Delete(hp,mp,1);
                         MenuItem(hp,mm,mp,100+mm,hp1); while hp1<>'#' do Readln(hd,hp1);
                   end;
         until hp='#'; z:=199;
         repeat Readln(hd,hp);
                if hp<>'#' then
                   begin Readln(hd,hp1); Inc(mm); Inc(z); mp:=pos('"',hp); Delete(hp,mp,1);
                         MenuItem(hp,mm,mp,z,hp1); while hp1<>'#' do Readln(hd,hp1);
                   end;
         until hp='#';
         PopSublevel;
      MenuItem(' Beenden ',10,2,2,'CONFIG.SYS wird gespeichert und mit REBOOT aktiviert');
      PopSublevel;
      ResetMenu(M); Close(hd);
end;

procedure Read_cs(dname:String);
begin cs[1]:='DEVICE =fixt_drv.sys';
      cs[2]:='FILES  = 20';
      cs[3]:='BUFFERS= 10';
      Assign(csd,path+'VAR.CS'); Reset(csd); csa:=3;
      repeat Readln(csd,cs[csa+1]); csa:=csa+1; until cs[csa]='#'; Close(csd); csa:=csa-1;
      if dname<>'' then
         begin Assign(csd,path+dname); Reset(csd); Readln(csd); Readln(csd,FILES,BUFFERS);
               cs[2]:=''; Str(FILES  :3,cs[2]); cs[2]:='FILES  ='+cs[2];
               cs[3]:=''; Str(BUFFERS:3,cs[3]); cs[3]:='BUFFERS='+cs[3];
               while not Eof(csd) do
               begin Readln(csd,cs[csa+1]); csa:=csa+1; end;
               Close(csd);
         end;
      cs[csa+1]:='shell  =D:\UTILITYS\BATCH\mbatch.exe /E:2000'; csa:=csa+1;
end;

procedure Draw_cs(x,y:Integer);
  var i,j:Integer;
begin ClearWindow(1,zaA,80,zaE,$0E);     {men1^.Root^.Colors[FrameColor]}
      DrawFrame(1,zaA,80,zaE,$0E,Frame1);
{      men1^.Root^.Colors[FrameColor]      men1^.Root^.Frame}
      TextBackground(Black); TextColor(Yellow);
      for i:=1 to zaE-zaA-1 do
          for j:=2 to 79 do
              if csa>=y+i-1 then
                 begin GotoXY(j,zaA+i);
                       if Length(cs[y+i-1])>=x+j-2 then Write(cs[y+i-1][x+j-2])
                                                   else Write(' ');
                 end;
end;

function drv(s1:String):Boolean;
  Label E;
begin drv:=FALSE;
      for csi:=1 to csa do
          if pos(s1,cs[csi])>0 then begin drv:=TRUE; Goto E; end;
E:
end;

procedure driver_deak(s1,s2:String);
  Label E;
begin for csi:=1 to csa do
          if pos(s1,cs[csi])>0 then
             begin while csi<csa do
                         begin cs[csi]:=cs[csi+1]; csi:=csi+1; end;
                         csa:=csa-1; Goto E;
             end;
          cs[csa+1]:=cs[csa]; csa:=csa+1;
          cs[csa-1]:=s2;
E:    Draw_cs(1,1);
{      DrawSubMenu(men1^.Active,men1^.UserFunc);}
end;

procedure InitMenu3;
  var M           : Menu;
      mk1         : MenuKey;
      s1,s2,s3    : String;
      l1,l2,p1,p2 : Integer;
      hd          : Text;
      mm,mp       : Integer;
begin {Customize this call for special exit characters and custom item displays}
      M := NewMenu([], nil); Assign(hd,path+'VAR.CS'); Reset(hd); s1:=''; while s1<>'#' do Readln(hd,s1);
      p1:=mk-105; for p2:=1 to p1 do
                      repeat Readln(hd,s1);
                      until s1='#';
      Readln(hd); Readln(hd); Readln(hd,s1); Readln(hd,s2); Readln(hd,l1,l2); Close(hd);
      l2:=l2+1; if l2>10 then l2:=10;

      SubMenu(48,22-l2,24,Vertical,Frame1,Color2,s1); mk1:=1;
      while mk1<l2 do
      begin if l1=0 then MenuItem('          GerÑt     '+chr(ord('0')+mk1-1)+'        ',mk1,21,mk1,'')
                    else MenuItem('          GerÑt     '+chr(ord('1')+mk1-1)+'        ',mk1,21,mk1,'');
            Inc(mk1);
      end;
      MenuItem('      GerÑt    entfernen     ',mk1,16,mk1,'');
      PopSublevel;
      ResetMenu(M); mk1:=MenuChoice(M,Ch);

      if Ch<>#27 then
         begin p2:=Pos('.sys',s2); if p2=0 then p2:=Pos('.SYS',s2); p1:=p2;
               while s2[p1-1]<>'\' do p1:=p1-1; s3:=copy(s2,p1-1,p2-p1+5);
               if drv(s3) then driver_deak(s3,'');
               if l1=0    then begin p1:=Pos('%1',s2); Delete(s2,p1,2); Insert(chr(ord('0')+mk1-1),s2,p1); end
                          else begin p1:=Pos('%1',s2); Delete(s2,p1,2); Insert(chr(ord('1')+mk1-1),s2,p1); end;
               if mk1<l2  then driver_deak(s3,s2);
         end;
end;

procedure InitMenu4;
  var M              : Menu;
      mk1            : MenuKey;
      s1,s2,s3       : String;
      l1,l2,p1,p2,p3 : Integer;
      hd             : Text;
      mm,mp          : Integer;
begin {Customize this call for special exit characters and custom item displays}
      M := NewMenu([], nil); Assign(hd,path+'VAR.CS'); Reset(hd); s1:='';
      repeat repeat Readln(hd,s1); until s1='#'; Readln(hd,s1); until s1='#';
      p1:=mk-200; for p2:=1 to p1 do repeat Readln(hd,s1); until s1='#';
      Readln(hd); Readln(hd); Readln(hd,s1); Readln(hd,l1);
      if l1>20 then l1:=20;

      SubMenu(48,22-l1,24,Vertical,Frame1,Color2,s1); mk1:=1;
      while mk1<=l1 do
      begin Readln(hd,s1); Readln(hd,s2); Readln(hd); l2:=Pos('"',s1); Delete(s1,l2,1);
            MenuItem(s1,mk1,l2,mk1,s2); Inc(mk1);
      end;
      PopSublevel;  Close(hd);
      ResetMenu(M); mk1:=MenuChoice(M,Ch);

      if Ch<>#27 then
      begin Reset(hd); s1:='';
            repeat repeat Readln(hd,s1); until s1='#'; Readln(hd,s1); until s1='#';
            for p2:=1 to p1 do repeat Readln(hd,s1); until s1='#';
            Readln(hd); Readln(hd); Readln(hd); Readln(hd);
            for p2:=1 to l1 do
                begin Readln(hd); Readln(hd); Readln(hd,s1);
                      l2:=Pos('.sys',s1); if l2=0 then l2:=Pos('.SYS',s1); p3:=l2;
                      while s1[p3-1]<>'\' do p3:=p3-1; s3:=copy(s1,p3-1,l2-p3+5);
                      if (drv(s3)) and (mk1<>p2) then driver_deak(s3,'');
                      if                 mk1=p2  then driver_deak(s3,s1);
                end;
      end;
end;


begin ClearWindow(1,1,80,25,$0F); TextAttr:=$4E; GotoXY(60,25); Write(copyrc);
      Assign(csd,'C:\CONFIG.SYS'); SetFAttr(csd,Archive);

      InitMenu1(men1); repeat mk:=MenuChoice(men1,Ch); until Ch=#13;
      if mk=csi then Read_cs('')
                else begin FindFirst(path+'*.CS',AnyFile,S_Rec); csa:=0;
                           while (DosError=0) and (mk<>csa) do
                           begin if S_Rec.Name<>'VAR.CS' then csa:=csa+1;
                                 if mk<>csa then FindNext(S_Rec);
                           end; Read_cs(S_Rec.Name);
                           Goto Ende;
                     end;

{$IFDEF Lib}
      men1:=ReadMenuLib('CONSYS2.LIB','MSH',nil);
{$ELSE}
      InitMenu2(men1);
{$ENDIF}

      ResetMenu(men1); Draw_cs(1,1);
      repeat mk:=MenuChoice(men1,Ch);
             case mk of
              31: begin for csi:=1 to csa do
                            if pos('FILES',cs[csi])>0 then
                               begin EditStr:=copy(cs[csi],pos('=',cs[csi])+1,length(cs[csi])-pos('=',cs[csi]));
                                     Goto E31;
                               end;
E31:                    EditZ(3,pos('=',cs[csi])+1,zaA+csi-1,20,zaA+csi+1);
                        Delete(cs[csi],pos('=',cs[csi])+1,length(cs[csi])-pos('=',cs[csi]));
                        cs[csi]:=cs[csi]+EditStr;
                  end;
              32: begin for csi:=1 to csa do
                            if pos('BUFFERS',cs[csi])>0 then
                               begin EditStr:=copy(cs[csi],pos('=',cs[csi])+1,length(cs[csi])-pos('=',cs[csi]));
                                     Goto E31;
                               end;
E32:                    EditZ(3,pos('=',cs[csi])+1,zaA+csi-1,20,zaA+csi+1);
                        Delete(cs[csi],pos('=',cs[csi])+1,length(cs[csi])-pos('=',cs[csi]));
                        cs[csi]:=cs[csi]+EditStr;
                  end;
              33: begin cs[csa+1]:=cs[csa]; csa:=csa+1; cs[csa-1]:='DEVICE =';
                        EraseMenu(men1,FALSE); Draw_cs(1,1);
                        EditStr:=''; EditZ(-255,9,zaA+csa-2,80,zaA+csa);
                        if EditStr='' then begin cs[csa-1]:=cs[csa]; csa:=csa-1; end
                                      else cs[csa-1]:=cs[csa-1]+EditStr;
                  end;
              34: begin GotoXY(60,19); Write('SuchZeichenfolge');
                        EditStr:=''; EditZ(-255,60,20,78,22);
                        EraseMenu(men1,FALSE); Draw_cs(1,1);
                        if (EditStr<>'') and drv(EditStr) then
                           begin EditStr:=copy(cs[csi],9,Length(cs[csi])-8);
                                 Delete(cs[csi],9,Length(cs[csi])-8);
                                 EditZ(-255,9,zaA+csi-1,80,zaA+csi+1);
                                 if EditStr='' then begin while csi<csa do
                                                          begin cs[csi]:=cs[csi+1]; csi:=csi+1; end;
                                                          csa:=csa-1;
                                                    end
                                               else cs[csi]:=cs[csi]+EditStr;
                           end;
                  end;

        100..199: InitMenu3;

        200..299: InitMenu4;

             end;
             EraseMenu(men1,FALSE); Draw_cs(1,1);
      until mk=2;
Ende: ClearWindow(1,1,80,25,$CE); TextBackground(red);
      GotoXY(30,10); Writeln('Bitte Warten !!!');
      GotoXY( 7,12); Writeln('Der Rechner wird mit den ausgewÑhlten Parametern gestartet.');
      Assign(csd,'C:\CONFIG.SYS'); Rewrite(csd); csi:=0;
      for csi:=1 to csa do Writeln(csd,cs[csi]);
      Close(csd); SetFAttr(csd,ReadOnly);
{$IFDEF Debug}
{$ELSE}
      inline($CD/$19);
{      if Mem[$F000:$FFFE]=$FC then inline($CD/$19)
                               else inline($EA/$5B/$E0/$00/$F0);}
{$ENDIF}
end.
