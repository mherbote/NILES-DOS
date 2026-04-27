{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit Handle1_;

interface

     uses   dos,crt,Handle_;

     procedure Handle_Erase(Handle:Word; Name:String);
     procedure Handle_Seek (Handle:Word; access:Byte; var HiOff,LoOff:Word);

implementation

     var    Reg              :                                  Registers;

     procedure Handle_Erase(Handle:Word; Name:String);
       var Name1:String;
     begin Name1:=Name+#0;
           Reg.AH:=65; Reg.DS:=Seg(Name1[1]); Reg.DX:=Ofs(Name1[1]);
           MsDos(Reg); Handle:=Reg.AX;
{$IFDEF Debug } GotoXY( 1,20); ClrEol;
                Write('Handle_Erase:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
     end;

     procedure Handle_Seek(Handle:Word; access:Byte; var HiOff,LoOff:Word);
     begin Reg.AH:=66; Reg.AL:=access; Reg.BX:=Handle; Reg.CX:=HiOff; Reg.DX:=LoOff;
           MsDos(Reg); Handle:=Reg.AX; HiOff:=Reg.DX; LoOff:=Reg.AX;
{$IFDEF Debug } GotoXY( 1,20); ClrEol;
                Write('Handle_Seek:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
     end;

end.
