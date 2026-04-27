uses crt,dos;

const c1 = $AA;
      c2 = $55;

var  i1,o1   : File of Byte;
     bb      :         Byte;
     cv1,cv2 :         Integer;
     cc      :         Integer;

begin Assign(i1,'dbcl.hlp'); Reset(i1); Assign(o1,'dbcl.tst'); Rewrite(o1);
      cc:=0; cv1:=c1; cv2:=c2;
      while not Eof(i1) do
      begin Read (i1,bb); bb:=bb+cv1-cv2; cv2:=cv2+1; cc:=cc+1;
                          if cc=129 then begin cc:=0; cv1:=cv1+cv2; end;
            Write(o1,bb);
      end;
      Close(i1); Close(o1);
end.