-module(client).

-include("../include/records.hrl").

-export([   request_landing/4,
            request_taking_off/4,
            print_queue/1]).

%% Client (Aircrafts)

request_landing(Pid, Name, Time, Delay) ->
    Pid ! {self(), {
        #plane{mode=land, name=Name, time=Time, delay=Delay}
    }},
    receive
        {_, Msg} -> Msg
    end.

request_taking_off(Pid, Name, Time, Delay) ->
    Pid ! {self(), {
        #plane{mode=take_off, name=Name, time=Time, delay=Delay}
    }},
    receive
        {_, Msg} -> Msg
    end.

print_queue(Pid) ->
    Pid ! {self(), release},
    receive
        {_, Msg} -> Msg
    end.