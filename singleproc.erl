%% @author wlt
%% @doc @todo Add description to singleproc.


-module(singleproc).

%% ====================================================================
%% API functions
%% ====================================================================

- export ([ do/1, p1/0, p2/0, p3/0, p4/0, p5/0, p6/0, test/1]).

do ({ output , E }) ->
io : format ("~p ~n" ,[E]);

do ({ input , E }) ->
io : format ("~p ~n" ,[E]);

do ([]) ->
ok ;

do ([ E | MoreEs ]) ->
do ( E ) ,
do ( MoreEs );
do (_) ->
io : format ("Unknown argument to do /1~n").

test(A) ->
	X = rand:uniform(2),
	if 
		A == 1 ->
			do([{input,"a"},{input,"b"},{output,"a"},{output,"b"},[]]);
		A == 2 ->
			do([{input,"a"},{output,"b"}]),
			test(2);
		A == 3 ->
			if X == 1->
				do([{input,"a"},[]]);
			true ->
				do([{input,"b"},[]])
			end;
		A == 4 ->
			if X == 1->
				test(4);
			true ->
				do([{input,"b"},[]])
			end;
		A == 5 ->
			if X == 1->
				do({input,"a"}),
				test(6);
			true ->
				do([{output,"b"},[]])
			end;
		A == 6 ->
			do({output,"b"}),
			test(5)
	end.

p1() ->
	do([{input,"a"},{input,"b"},{output,"a"},{output,"b"},[]]).

p2() ->
	do([{input,"a"},{output,"b"}]),
	p2().

p3() ->
	X = rand:uniform(2),
	if  X == 1 ->
			do([{input,"a"},[]]);
		true ->
			do([{input,"b"},[]])
	end.
p4() ->
	X = rand:uniform(2),
	if X == 1->
		p4();
		true ->
			do([{input,"b"},[]])
	end.
p5() ->
	X = rand:uniform(2),
	if X == 1->
			do({input,"a"}),
			p6();
		true ->
			do([{output,"b"},[]])
	end.
p6() ->
	do({output,"b"}),
	p5().

%% ====================================================================
%% Internal functions
%% ====================================================================


