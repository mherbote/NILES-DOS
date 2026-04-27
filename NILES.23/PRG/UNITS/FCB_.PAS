{$R-,S-,I-,D-,F-,V+,B+,N-,L- }
{$M 1500,0,0 }
{$DEFINE Debug }
{$UNDEF  Debug }

unit FCB_;

interface

     uses   dos,crt;

     type   FCB              = record erw      :                Byte;
                                      res1     : array[1..5] of Byte;
                                      attr     :                Byte;
                                      drive    :                Byte;
                                      name     : array[1..8] of char;
                                      ext      : array[1..3] of char;
                                      curr_blk :                Word;
                                      rec_size :                Word;
                                      size_lo  :                Word;
                                      size_hi  :                Word;
                                      date     :                Word;
                                      time     :                Word;
                                      res2     : array[1..8] of Byte;
                                      curr_rec :                Byte;
                                      rnd_lo   :                Word;
                                      rnd_hi   :                Word;
                               end;
            DTA              =               array[1..32768] of Byte;

     var    _hi,_lo          :                                  Word;
            Reg              :                                  Registers;
            FCB_1            :                                  FCB;
            DTA_             :                                  DTA;

     procedure FCB_O(drive:Byte; name,ext:string);
     procedure FCB_R(lng:Word);
     procedure FCB_C;

implementation

     procedure FCB_O(drive:Byte; name,ext:string);
       var i:Integer;
     begin FCB_1.erw  :=$FF;  FCB_1.attr:=$07;   FCB_1.name:='        '; FCB_1.ext:='   ';
           FCB_1.curr_rec:=0; FCB_1.curr_blk:=0;
           FCB_1.size_hi :=0; FCB_1.size_lo :=0; FCB_1.rnd_hi :=0; FCB_1.rnd_lo :=0;
           for i:=1 to 5 do FCB_1.res1[i]:=0;
           for i:=1 to 8 do FCB_1.res2[i]:=0;
           FCB_1.drive:=drive; move(name[1],FCB_1.name[1],length(name));
                               move(ext [1],FCB_1.ext [1],length(ext ));
           Reg.AH:=15;
           Reg.DS:=Seg(FCB_1); Reg.DX:=Ofs(FCB_1); MsDos(Reg);
           _hi:=FCB_1.size_hi; _lo:=FCB_1.size_lo;
     end;

     procedure FCB_R(lng:Word);
     begin FCB_1.rec_size:=lng;
           Reg.AH:=26; Reg.DS:=Seg(DTA_[1]); Reg.DX:=Ofs(DTA_[1]); MsDos(Reg);
           Reg.AH:=20; Reg.DS:=Seg(FCB_1  ); Reg.DX:=Ofs(FCB_1  ); MsDos(Reg);
           {$IFDEF Debug } GotoXY(3,23);
                           writeln('FCB_R:',Reg.Flags and FCarry,',',Reg.AL,'/',lng,'/     ');
           {$ENDIF}
     end;

     procedure FCB_C;
     begin Reg.AH:=16; Reg.DS:=Seg(FCB_1); Reg.DX:=Ofs(FCB_1); MsDos(Reg); end;

end.
