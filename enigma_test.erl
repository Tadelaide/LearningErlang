-module(enigma_test).
-author("Letian Wang").

-include_lib("eunit/include/eunit.hrl").

%% A simple test from
%% http://gcc.eisbehr.de/manual/en/enigma.html
simple_test() ->
    Enigma = enigma:setup("B",["II","I","III"],[26,23,4],[{$E,$Z}, {$B,$L}, {$X,$P}, {$W,$R}, {$I,$U}, {$V,$M}, {$J,$O}]),
    Res = enigma:crypt([$A,$G,$I],Enigma,"WBCG QLUWJ FCKLW MQIXW PDYVI EIRLY SDQRI ANEQQ QIZRW MIKFW NKZNG SVKZV VWXNB FNQDO"),
    ?assertEqual("THIS ISANE XAMPL EMESS AGEXB ROUGH TTOYO UBYGC CXQEE RSAND HAVEF UNWIT HTHEE NIGMA",Res).