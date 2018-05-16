-module(enigma_test).
-author("Letian Wang").

-include_lib("eunit/include/eunit.hrl").

%copy it from pdf documents, just for test the message send between every process. However, there are many bugs.
simple_test() ->
    Enigma = enigma:setup("B",["III","I","III"],[12,6,18],[{$A,$E}, {$F,$J}, {$P,$R}],{$D,$F,$R}),
    Result = enigma:crypt(Enigma,"WBCG QLUWJ FCKLW MQIXW PDYVI EIRLY SDQRI ANEQQ QIZRW MIKFW NKZNG SVKZV VWXNB FNQDO").
