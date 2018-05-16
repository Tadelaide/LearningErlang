%% @author wlt
%% @doc @todo Add description to pingpong.

- module (pingpong).
%% ====================================================================
%% API functions
%% ====================================================================

- export ([ start/0, ping/2, pong/1]).
ping (0 , Pong_PID ) ->
    Pong_PID ! finished ,
    io : format ("Pong mail message is taken 666Ping finished~n" ,[]);

ping (N , Pong_PID ) ->
    io : format("~p,www~p~n", [N,Pong_PID]),
    Pong_PID ! { ping , self ()} ,
    io : format("Pong mail message is taken ~p ~n", [self()]),
    %io : format("11111111111111~n", []),
    receive
            pong ->
                io : format ("Ping mail message is over Ping received pong~n" ,[])
    end,
    %io : format("NNN~n", []),
    ping ( N - 1 , Pong_PID ).
    %io : format("ping is over~n",[]).

pong (0) ->
            io : format ("Pong mail message is over finished~n" ,[]);
pong (N) ->
    io : format("pong() start~n", []),
    receive

        { ping , Ping_PID } ->
            %io : format("Pong mail message is over 111~n", []),
            %io : format("Pong mail message is over 222~n", []),
            %io : format("Pong mail message is over 333~n", []),
            %io : format("Pong mail message is over 444~n", []),
            io : format ("Pong received from ~p ping~n" ,[Ping_PID]),
            io : format ("!!!!! from ~p ping!!!!!~n" ,[self()]),
            Ping_PID ! pong ,
            %io : format("Ping mail message is taken bbb~n", []),
            pong (N);
        finished ->
            pong (N-1)
            %io : format ("Pong mail message is over finished~n" ,[])
                
    end.
    %io : format("ooo~n", []).


start () ->
    Pong_PID = spawn ( pingpong , pong , [2]) ,
    %io : format (" Ping !!~p!!finished~n" , [Pong_PID]),
    spawn ( pingpong , ping , [1 , Pong_PID ]),
    io : format("the 123second process start~n",[]),
    %Pong_PID2 = spawn ( pingpong , pong , []) ,
    io : format("the second process start~n",[]),
    spawn ( pingpong , ping , [5 , Pong_PID ]).

%% ====================================================================
%% Internal functions
%% ====================================================================
