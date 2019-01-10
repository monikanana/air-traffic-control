-module(client).

-include("../include/records.hrl").

-export([   request_landing/5,
            request_taking_off/4,
            print_queue/1]).

%% Client (Aircrafts)

request_landing(Pid, Name, Land, Fuel, Delay) ->
    Pid ! {self(), {
        #air{name=Name, time_to_land=Land, time_on_fuel=Fuel, delay=Delay}
    }},
    receive
        {_, Msg} -> Msg
    end.

request_taking_off(Pid, Name, Time, Delay) ->
    Pid ! {self(), {
        #ground{name=Name, time_to_take_off=Time, delay=Delay}
    }},
    receive
        {_, Msg} -> Msg
    end.

print_queue(Pid) ->
    Pid ! {self(), release},
    receive
        {_, Msg} -> Msg
    end.