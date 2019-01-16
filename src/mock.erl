-module(mock).

-include("../include/records.hrl").

-export([random_aircraft/0, generate_aircrafts/1, mock/2, read_lines/1]).

-import(client,[request/5]).
-import(server,[start/0]).



random_aircraft() ->
    Aircrafts = read_lines("./src/mock/aircrafts.txt"),
    Mode = [land, take_off],
    {
        lists:nth(rand:uniform(length(Mode)), Mode),
        lists:nth(rand:uniform(length(Aircrafts)), Aircrafts),
        floor(rand:uniform()*10)+1,
        floor(rand:uniform()*5)
    }.

read_lines(FileName) ->
    {ok, Binary} = file:read_file(FileName),
    string:tokens(erlang:binary_to_list(Binary), "\n").


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


