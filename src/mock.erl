-module(mock).

-export([random_aircraft/0, generate_aircrafts/1, mock/2]).

-import(client,[request/5]).
-import(server,[start/0]).

random_aircraft() ->
    Aircrafts = ["Airbus A320", "Airbus A300", "Airbus A310", "Airbus A330", "Airbus A340", "Airbus A350", "Airbus A380",
                 "Boeing 747", "Boeing 747-400", "Boeing 747-8", "Boeing 767", "Boeing 777", "Boeing 787"],
    Mode = [land, take_off],
    {
        lists:nth(rand:uniform(length(Mode)), Mode),
        lists:nth(rand:uniform(length(Aircrafts)), Aircrafts),
        floor(rand:uniform()*100)+30,
        floor(rand:uniform()*10)
    }.

generate_aircrafts(N) ->
    lists:foldl(
        fun(_, Acc) -> [random_aircraft()] ++ Acc end,
        [],
        lists:seq(1,N)
    ).

mock(N, Server) ->
    %Server = server:start(),
    lists:foreach(
        fun({Mode,Name,Time,Delay}) ->
            client:request(Server,Mode,Name,Time,Delay) end,
        generate_aircrafts(N)
    ).
    %Server.