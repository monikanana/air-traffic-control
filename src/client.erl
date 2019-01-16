-module(client).

-include("../include/records.hrl").

-export([request/5]).

%% Client (Aircrafts)

request(Server, Mode, Name, Time, Delay) ->
    Server ! {self(), {
        #plane{mode=Mode, name=Name, time=Time, delay=Delay}
    }}.