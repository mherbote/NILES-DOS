{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

{$I def.def }

unit Handle_;

interface

     uses   dos,crt;

{$IFDEF WBS_70 }
     const  DTAl             = 30000;
{$ELSE}
     const  DTAl             = 51200;
{$ENDIF}

     type   DTA              =               array[1..DTAl] of Byte;

     var    H1_,H2_          :                                  Word;
            FS1              :                                  Word;
            FS               :                                  LongInt;
            DTA_             :                                  DTA;

     procedure Handle_Create(var Handle:Word; attr:Word;   Name:string);
     procedure Handle_Open  (var Handle:Word; access:Byte; Name:string);
     function  Handle_Read  (    Handle:Word; lng:Word                ):Boolean;
     procedure Handle_Write (    Handle:Word; lng:Word                );
     procedure Handle_Close (    Handle:Word                          );

implementation

     var    Reg              :                                  Registers;

     procedure Handle_Create(var Handle:Word; attr:Word; Name:string);
       var Name1:string[80];
     begin Name1:=Name+#0;
           Reg.AH:=67; Reg.AL:=1;    Reg.CX:=   0; Reg.DS:=Seg(Name1[1]); Reg.DX:=Ofs(Name1[1]);
           MsDos(Reg);
           Reg.AH:=60;               Reg.CX:=attr; Reg.DS:=Seg(Name1[1]); Reg.DX:=Ofs(Name1[1]);
           MsDos(Reg); Handle:=Reg.AX;
{$IFDEF Debug } GotoXY( 1,24);
                Write('Handle_Create:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
     end;

     procedure Handle_Open(var Handle:Word; access:Byte; Name:string);
       var Name1:string[80];
     begin Name1:=Name+#0;
           Reg.AH:=61; Reg.AL:=access; Reg.DS:=Seg(Name1[1]); Reg.DX:=Ofs(Name1[1]);
           MsDos(Reg); Handle:=Reg.AX;
{$IFDEF Debug } GotoXY( 1,23);
                Write('Handle_Open:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
           Reg.AH:=66; Reg.AL:=2; Reg.BX:=Handle; Reg.CX:=0; Reg.DX:=0; MsDos(Reg);
           if (Reg.Flags and FCarry)=0 then FS:=Reg.DX*65536+Reg.AX;
           Reg.AH:=66; Reg.AL:=0; Reg.BX:=Handle; Reg.CX:=0; Reg.DX:=0; MsDos(Reg);
     end;

     function Handle_Read(Handle:Word; lng:Word):Boolean;
     begin Reg.CX:=lng;
           Reg.AH:=63; Reg.BX:=Handle; Reg.DS:=Seg(DTA_[1]); Reg.DX:=Ofs(DTA_[1]); MsDos(Reg);
{$IFDEF Debug } GotoXY( 1,24);
                Write('Handle_Read:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
           if (Reg.Flags and FCarry)=0 then Handle_Read:=true else Handle_Read:=false;
           FS1:=Reg.AX;
     end;

     procedure Handle_Write(Handle:Word; lng:Word);
     begin Reg.CX:=lng;
           Reg.AH:=64; Reg.BX:=Handle; Reg.DS:=Seg(DTA_[1]); Reg.DX:=Ofs(DTA_[1]); MsDos(Reg);
{$IFDEF Debug } GotoXY(41,24);
                Write('Handle_Write:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
     end;

     procedure Handle_Close(Handle:Word);
     begin Reg.AH:=62; Reg.BX:=Handle; MsDos(Reg);
{$IFDEF Debug } GotoXY(41,23);
                Write('Handle_Close:',Reg.Flags and FCarry,',',Reg.AX,'/');
{$ENDIF}
     end;

end.
