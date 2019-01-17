-module(server).

-include("../include/records.hrl").

-export([atc/1, compare/2]).

%% Server (ATC)

atc(Queue) ->
    receive
        % dodawanie samolotów do kolejki
        {_, A = #plane{}} ->
            atc(lists:sort(fun compare/2, Queue ++ [A]));

        % uruchomienie symulacji - uwolnienie kolejki
        {From, release} ->
            From ! {self(), Queue},
            atc(Queue)
    end.

-spec compare(#plane{}, #plane{}) -> boolean().
compare(A, B) ->
    case A#plane.time == B#plane.time of
        true ->
            A#plane.delay > B#plane.delay;
        _ -> 
            A#plane.time < B#plane.time
    end.
