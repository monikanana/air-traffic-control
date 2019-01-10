-module(server).

-include("../include/records.hrl").

-export([loop/1]).

%% Server (ATC)
loop(Queue) ->
    receive
        {From, request, {Operation, Aircraft}} ->
            From ! {self(), roger_that},
            loop([{Operation, Aircraft}|Queue]);
        {From, release} ->
            From ! {self(), Queue},
            loop(Queue)
    end.