-module(server).

-include("../include/records.hrl").

-export([loop/1, start/0, print_queue/1]).

%% Server (ATC)
start() ->
    spawn(server, loop, [[]]).


loop(Queue) ->
    receive

        {From, {A = #plane{}}} ->
            From ! {self(), roger_that},
            loop(lists:sort(fun compare/2, Queue ++ [A]));

        {From, release} ->
            From ! {self(), Queue},
            loop(Queue)
    end.

print_queue(Server) -> 
    Server ! {self(), release},
    receive
        {_, Msg} -> Msg
    end.


-spec compare(#plane{}, #plane{}) -> boolean().
compare(A, B) ->
    case A#plane.time == B#plane.time of
        true ->
            A#plane.delay > B#plane.delay;
        _ -> 
            A#plane.time < B#plane.time
    end.
