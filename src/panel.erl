-module(panel).

-include("../include/records.hrl").

-export([main/0, simulate_queue/1]).

-import(server,[start/0, compare/2]).
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
         mock(PID_ATC, input_number()),

         PID_SIMULATION = spawn(fun simulation/0),
         PID_ATC ! {PID_SIMULATION, release},
         PID_ATC_OBSERVER = spawn(fun atc_observer/0),
         PID_ATC_OBSERVER ! {start, PID_SIMULATION},

         run();
         
      Action =:= "2\n" ->

         Plane = io:get_line("Name of aircraft: "),
         file:write_file("./src/mock/aircrafts.txt", Plane, [append]),
         io:format("Aircraft created.\n"),
         io:format("Select option from menu: "),
         
         run();
      
      Action =:= "8\n" ->
         print_options(),
         run();

      Action =:= "9\n" ->
         draw_aircraft(),
         exit();
 
      true ->
         %io:format("Wrong action, use [8] to print avaible options.\n"),
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
                     io:fwrite("Terrorist attack happened. Airport cannot handle aircrafts requests.\n");

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
   io:format(os:cmd(clear)),
   timer:sleep(1000),
   receive
      {_, Queue} ->
         simulate_queue(Queue)
   end.

simulate_queue(Queue) -> 

   io:fwrite("You can press [x] to terminate simulation.\n"),
   timer:sleep(500),

   #plane{time=T} = lists:nth(1, Queue),
   case T of
      0 ->
         Queue_delayed = [lists:nth(1, Queue)] ++ lists:foldl(
            fun(P = #plane{time=Time, delay=Delay}, NewQueue) ->

               case Time of
                  0 -> NewQueue ++ [P#plane{time = Time + 1, delay = Delay + 1}];
                  _ -> NewQueue ++ [P]
               end
            end,
            [], 
            lists:nthtail(1, Queue)
         );
      _ -> 
         Queue_delayed = Queue
   end,

   Queue_delayed_sorted = lists:sort(fun server:compare/2, Queue_delayed),


   lists:foreach(
      fun(P = #plane{time=Time, name=Name}) ->
         case Time of
            0 ->
               io:format("~s is leaving the runaway.\n", [Name]);

            _ ->
               io:format("~p~n", [P])
         end
      end,
      Queue_delayed_sorted
   ), 

   Queue_filtered = lists:filter(fun(#plane{time=Time}) -> Time /= 0 end, Queue_delayed_sorted),

   Queue_decremented = lists:foldl(
      fun(P = #plane{time=Time}, NewQueue) -> 
         NewQueue ++ [P#plane{time = Time - 1}]
      end,
      [],
      Queue_filtered
   ),

   if 
      Queue_decremented /= [] ->
         %io:format("\n----------------------------\n"), 
         timer:sleep(2500),
         io:format(os:cmd(clear)),
         simulate_queue(Queue_decremented);

      true -> 
         io:format(os:cmd(clear)),
         io:format(">>> There is no planes in the queue. <<<\n\n"),

         print_options(),

         run()
   end.


exit() ->
   io:format("Program is shutting down.\n"),
   init:stop(0).