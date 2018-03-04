%% @author wlt
%% @doc @todo Add description to a.


-module(pingpong_test).

-include_lib("eunit/include/eunit.hrl").
%% ====================================================================
%% API functions
%% ====================================================================
%-export([nil/0,do/1,p1/2]).

expect(Val) ->
    receive
    Val ->
        ok;
    Other ->
        {error,Other}
    end.

ping1_test() ->
    PID = spawn(pingpong,ping,[1,self()]),
    ok = expect({ping,PID}),
    PID ! pong,
    ok = expect(finished).

%% ====================================================================
%% Internal functions
%% ====================================================================


