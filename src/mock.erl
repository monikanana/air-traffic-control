-module(mock).

-include("../include/records.hrl").

-export([random_aircraft/0, generate_aircrafts/1, mock/2]).

-import(client,[request/5]).
-import(server,[start/0]).

%% Macros 
-define(filepath, "./mock/aircrafts").


random_aircraft() ->
    Aircrafts = ["Airbus A320", "Airbus A300", "Airbus A310", "Airbus A330", "Airbus A340", "Airbus A350", "Airbus A380",
                 "Boeing 747", "Boeing 747-400", "Boeing 747-8", "Boeing 767", "Boeing 777", "Boeing 787"],
    Mode = [land, take_off],
    {
        lists:nth(rand:uniform(length(Mode)), Mode),
        lists:nth(rand:uniform(length(Aircrafts)), Aircrafts),
        floor(rand:uniform()*10)+1,
        floor(rand:uniform()*5)
    }.


generate_aircrafts(N) ->
    lists:foldl(
        fun(_, Acc) -> [random_aircraft()] ++ Acc end,
        [],
        lists:seq(1,N)
    ).

mock(Server, N) ->
    lists:map(
        fun({Mode,Name,Time,Delay}) ->
            Server ! {
                self(),
                #plane{mode=Mode, name=Name, time=Time, delay=Delay}
            }    
        end,
        generate_aircrafts(N)
    ).