{$R-,S-,I-,D-,F-,V+,B-,N-,L+ }
{$M 1500,0,0 }
{$define Debug }


begin if ParamCount=1 then ChDir(copy(ParamStr(1),1,length(ParamStr(1))-1));
end.
