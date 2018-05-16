%% @author wlt
%% @doc @todo Add description to a.


-module(a).

%% ====================================================================
%% API functions
%% ====================================================================
-export([start/0, ping/2, pong/1,main/1,lc_stuff/1,nil/0,do/1,p1/2,work/1,lookup/2,inPlugboard/2,transfer/1,count/1]).

nil() ->
ok.

do("a") ->
	io : format("~p ~n" , [123]).

%do("b") ->
%	io : format("~p ~n", "abc").

p1(A,B) ->
	do(A),
	do(B),
	do(A),
	do(B),
	nil().

transfer([CharacterA|CharacterB]) ->
	if 
		CharacterB == [] ->
			io : format ("2222~p\n" ,[CharacterA]);
		true ->
			io : format ("11111~p\n" ,[CharacterA]),
			transfer(CharacterB)
	end.

work(Character) ->
	ReflectorList = [{$A,$E}, {$B,$J}, {$C,$M}, {$D,$Z}, {$F,$L}, {$G,$Y}, {$H,$X}, {$I,$V}, {$K,$W}, {$N,$R}, {$O,$Q}, {$P,$U}, {$S,$T}],
	lookup(ReflectorList,Character).

inPlugboard(PlugboardPairs,Character) ->
	lookup(PlugboardPairs,Character),
	io : format ("The name of reflector is wrong" ,[]).


lookup([{InCharacter,OutCharacter}|Rest],Character) ->
	if 
		InCharacter == Character ->
			io : format("~p ~n",[OutCharacter]);
		Rest == [] ->
			io : format("something word ~pwrong.",[Character]);
		true ->
			lookup(Rest,Character)
	end.

main(LPL) ->
	lc_stuff(LPL).

lc_stuff([{N,M}|R]) ->
	% List1 = [{$A,$B},{$C,$D},{$Z,$X}],
	% List2 = [{In+10,Out+10}||{In,Out} <- List1 ],
	% List3 = [{In-26,Out}||{In,Out}  <- List2, In>$Z],
	% List4 = [{In,Out}||{In,Out}  <- List2, In =< $Z],
	% List5 = List3++List4,
	% List6 = [{In,Out-26}||{In,Out} <- List5, Out>$Z],
	% List7 = [{In,Out}||{In,Out} <- List5, Out=<$Z],
	% List8 = List7++List6,
	% List1.
	% case  LPL of
	% 	1->10;
	% 	2->20;
	% 	true -> "fuck"
	% end.
	io : format("something word ~pwron\n.",[{N,M}]),
	if
		N /= $A ->
			A = [{N,M}],
			NewList = R++A,
			lc_stuff(NewList);
		N == $A ->
			A =	[{N,M}],
			NewList = A++R,
			io : format("Finished~p\n.",[NewList])
	end.
count([H|R])->
	io : format("Finished~p\n.",[R]).



start() ->
	Pong_PID = spawn (a,pong,[2]) ,
    io : format (" Ping !!~p!!finished~n" , [Pong_PID]),
	spawn (a,ping,[1,Pong_PID]),
	io : format (" Ping !!~p!!finished~n" , [Pong_PID]).

ping(N,Pong_PID) ->
	io : format("~p,www~p~n", [N,Pong_PID]),
	Pong_PID ! { pin , self ()},
	io : format("NNN~n", []),
	io : format("NNN~n", []).
pong(N)->
		receive
			{ pin , Ping_PID } ->
				io : format("Pong mail message is over 111~n", []);
		finished ->
			io : format (" fuck~n")
end.
%% ====================================================================
%% Internal functions
%% ====================================================================


