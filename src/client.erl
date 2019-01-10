-module(client).

-include("../include/records.hrl").

-export([   request_landing/2,
            request_taking_off/2,
            print_queue/1]).

%% Client (Aircrafts)
request_landing(Pid, Aircraft) ->
    Pid ! {self(), request, {land, Aircraft}},
    receive
        {_, Msg} -> Msg
    end.

request_taking_off(Pid, Aircraft) ->
    Pid ! {self(), request, {take_off, Aircraft}},
    receive
        {_, Msg} -> Msg
    end.

print_queue(Pid) ->
    Pid ! {self(), release},
    receive
        {_, Msg} -> Msg
    end.