%% @author wlt
%% @doc @todo Add description to a.


-module(test).

%% ====================================================================
%% API functions
%% ====================================================================
-export([encode/2,encode/3,index/1]).

encode(Pin, Password) ->
    Code = {nil,nil,nil,nil,nil,nil,nil,nil,nil,
            nil,nil,nil,nil,nil,nil,nil,nil,nil,
            nil,nil,nil,nil,nil,nil,nil,nil},
    encode(Pin, Password, Code).
 
encode([], _, Code) ->
    Code;
encode(Pin, [], Code) ->
    io:format("Out of Letters~n",[]);
 
encode([H|T], [Letter|T1], Code) ->
    Arg = index(Letter) + 1,
    io:format("Out123123123www~p~n ",[Arg]),
    case element(Arg, Code) of
        nil ->
            encode(T, T1, setelement(Arg, Code, index(H)));
        _ ->
            encode([H|T], T1, Code)
    end.
 
index(X) when X >= $0, X =< $9 ->
    X - $0;
 
index(X) when X >= $A, X =< $Z ->
    X - $A.
%% ====================================================================
%% Internal functions
%% ====================================================================


