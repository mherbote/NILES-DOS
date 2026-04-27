uses crt,dos;

const c1 = $AA;
      c2 = $55;

var  i1,o1   : File of Byte;
     bb      :         Byte;
     cv1,cv2 :         Integer;
     cc      :         Integer;

begin ClrScr;
      Assign(i1,'dbcl.tst'); Reset(i1);
      cc:=0; cv1:=c1; cv2:=c2;
      while not Eof(i1) do
      begin Read (i1,bb); bb:=bb-cv1+cv2; cv2:=cv2+1; cc:=cc+1;
                          if cc=129 then begin cc:=0; cv1:=cv1+cv2; end;
            Write(chr(bb));
      end;
      Close(i1);
end.