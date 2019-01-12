-module(client).

-include("../include/records.hrl").

-export([   print_queue/1,
            request/5]).

%% Client (Aircrafts)

request(Server, Mode, Name, Time, Delay) ->
    Server ! {self(), {
        #plane{mode=Mode, name=Name, time=Time, delay=Delay}
    }},
    receive
        {_, Msg} -> Msg
    end.

print_queue(Pid) ->
    Pid ! {self(), release},
    receive
        {_, Msg} -> Msg
    end.