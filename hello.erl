%% @author wlt
%% @doc @todo Add description to hello.


-module(hello).

%% ====================================================================
%% API functions
%% ====================================================================
-export([say/1,respond/1,abc/1,sum/1,nth/2]).

say ( A ) ->
io : format ("Hello,~p ~n",[A]).
respond ( mike ) ->
" Hi mike !";
respond (42) ->
meaningoflife ;
respond ({ mytuple , _ }) ->
" You gave me a pair but I ignored half of it ".

abc({A,B,C}) ->
io : format("Hello ,~p ~n",[B]).



sum(List) ->
	sum(List,0).

sum([Head | Rest], SumResult) ->
	sum(Rest, SumResult+Head);
sum([],SumResult) ->
	SumResult.

nth(List,X) ->
	Count = 1,
	nth(List,X,Count).

nth([Head | Rest],X,Count)->
	ABC = 1,
	if
		X == Count ->
			io : format ("HELLO, ~p ~n",[Count]);
		true ->
			nth(Rest,X,Count+ABC)
	end.
			

	


%% ====================================================================
%% Internal functions
%% ====================================================================


