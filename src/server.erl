-module(server).

-include("../include/records.hrl").

-export([loop/1, start_server/0]).

%% Server (ATC)
start_server() ->
    spawn(server, loop, [[]]).


loop(Queue) ->
    receive

        {From, {A = #air{mode=land}}} ->
            From ! {self(), roger_that},
            loop(lists:sort(fun compare_airs/2, Queue ++ [A]));

        {From, {A = #ground{mode=take_off}}} ->
            From ! {self(), roger_that},
            loop(lists:sort(fun compare_grounds/2, Queue ++ [A]));

        {From, {A = #plane{}}} ->
            From ! {self(), roger_that},
            loop(lists:sort(fun compare/2, Queue ++ [A]));

        {From, release} ->
            From ! {self(), Queue},
            loop(Queue)
    end.

-spec compare(#plane{}, #plane{}) -> boolean().
compare(A, B) ->
    case A#plane.time == B#plane.time of
        true ->
            A#plane.delay > B#plane.delay;
        _ -> 
            A#plane.time < B#plane.time
    end.

-spec compare_airs(#air{}, #air{}) -> boolean().
compare_airs(A, B) ->
    case A#air.time_to_land == B#air.time_to_land of
        true ->
            case A#air.time_on_fuel == B#air.time_on_fuel of
                true ->
                    A#air.delay > B#air.delay;
                _ ->
                    A#air.time_on_fuel < B#air.time_on_fuel
            end;
        _ -> 
            A#air.time_to_land < B#air.time_to_land
    end.

-spec compare_grounds(#ground{}, #ground{}) -> boolean().
compare_grounds(A, B) ->
    case A#ground.time_to_take_off == B#ground.time_to_take_off of
        true ->
            A#ground.delay > B#ground.delay;
        _ -> 
            A#ground.time_to_take_off < B#ground.time_to_take_off
    end.