-module(server).

-include("../include/records.hrl").

-export([atc/1, get_queue/1]).

%% Server (ATC)

atc(Queue) ->
    receive
        % dodawanie samolotów do kolejki
        {From, {A = #plane{}}} ->
            From ! {self(), roger_that},
            atc(lists:sort(fun compare/2, Queue ++ [A]));

        % uruchomienie symulacji - uwolnienie kolejki
        {From, release} ->
            From ! {self(), Queue},
            atc(Queue)
    end.

get_queue(Server) -> 
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
