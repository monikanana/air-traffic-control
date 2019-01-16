-module(panel).

-include("../include/records.hrl").

-export([main/0, simulate_queue/1]).

-import(client,[request/5]).
-import(server,[start/0]).
-import(mock,[mock/2]).
-import(utils,[print_options/0, draw_aircraft/0, input_number/0]).


main() ->
   io:format("The airport traffic control is ready to use.\n"),
   print_options(),   
   run().

run() ->
   Action = io:get_line(""),
   
   if
      Action =:= "1\n" ->
      
         PID_ATC = spawn(server, atc, [[]]),           
         mock(PID_ATC, input_number()),   % mam gotową kolejkę samolotów

         PID_SIMULATION = spawn(fun simulation/0),
         PID_ATC ! {PID_SIMULATION, release},
         PID_ATC_OBSERVER = spawn(fun atc_observer/0),
         PID_ATC_OBSERVER ! {start, PID_SIMULATION},

         run();

      Action =:= "2\n" ->
         io:format("Nothing happens in this mode now.\n"),
         run();
         
      Action =:= "8\n" ->
         print_options(),
         run();

      Action =:= "9\n" ->
         draw_aircraft(),
         exit();
 
      true ->
         io:fwrite("Wrong action, try again. Use '8' to check all available option\n"),
         run()
   end.

atc_observer() ->
   receive 
        {start, PID_SIMULATION} ->
            Action = io:get_line(""),   
            if 
                Action =:= "x\n" ->
                     PID_NEW_MAIN = spawn(fun new_run/0),
                     PID_NEW_MAIN ! start,
                     exit(PID_SIMULATION, kill),
                     io:fwrite("Terrorism attack happened. Airport cannot handle aircrafts requests.\n");

                true ->
                    atc_observer()
            end,
            atc_observer()
    end.


new_run() ->
    receive
        start ->
            main()
    end.

simulation() ->
   receive
      {_, Queue} ->
         io:format("\n----------------------------\nSIMULATION:\n\n"),
         simulate_queue(Queue)
   end.

simulate_queue(Queue) -> 

   lists:foreach(
      fun(P = #plane{time=Time, name=Name}) ->
         case Time of
            0 ->
               io:format("~s is leaving the runaway.\n", [Name]);

            _ -> 
               io:format("~p~n", [P])
         end
      end,
      Queue
   ), 

   Queue_filtered = lists:filter(fun(#plane{time=Time}) -> Time /= 0 end, Queue),

   Queue_decremented = lists:foldl(
      fun(P = #plane{time=Time}, NewQueue) -> 
         NewQueue ++ [P#plane{time = Time - 1}]
      end,
      [],
      Queue_filtered
   ),

   if 
      Queue_decremented /= [] ->
         io:format("\n----------------------------\n"), 
         timer:sleep(1000),
         simulate_queue(Queue_decremented);
      true -> 
         io:format(">>> There is no planes in the queue. <<<\n"), 
         run()
   end.



exit() ->
   io:format("Program is going be down.\n"),
   init:stop(0).