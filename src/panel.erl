-module(panel).

-include("../include/records.hrl").

-export([main/0]).

-import(client,[request/5]).
-import(server,[start/0]).
-import(utils,[input_aircraft_values/0, input_mode/0, print_options/0, draw_aircraft/0]).


main() ->
   io:format("The airport traffic controll is ready to use.\n"),
   print_options(),   
   run().

run() ->
   Action = io:get_line(""),
   if

      Action =:= "1\n" ->
      
         PID_ATC = spawn(server, atc, [[]]),             % nasluchuje na dodawanie samolotow do kolejki
         %PID_ATC_OBSERVER = spawn(panel, atc_observer, [PID_ATC]),   % nasluchuje na kolejke do wyswietlenia
         
         PID_ATC ! {self(), #plane{name="Name", mode=land, time=3, delay=3}},
         PID_ATC ! {self(), #plane{name="Name", mode=land, time=0, delay=2}},
         %PID_ATC ! {self(), #plane{name="Name", mode=land, time=10, delay=6}},
         %PID_ATC ! {self(), #plane{name="Name", mode=land, time=14, delay=3}},
         %PID_ATC ! {self(), #plane{name="Name", mode=land, time=14, delay=1}},

         PID_ATC ! {self(), release},
         receive
            {_, Queue} ->
               simulate_queue(Queue)
         end,
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

simulate_queue(Queue) -> 

   % printuj całą listę razem z zerami
   lists:foreach(fun(P) -> io:format("~p~n", [P]) end, Queue), 

   % jesli ktorys samolot ma time=-1 to usun go z listy
   Queue_filtered = lists:filter(fun(#plane{time=Time}) -> Time /= -0 end, Queue),

   % dla każdego samolotu decrementuj time
   Queue_decremented = lists:foldl(
      fun(P = #plane{time=Time}, NewQueue) -> 
         NewQueue ++ [P#plane{time = Time - 1}]
      end,
      [],
      Queue_filtered
   ),

   if 
      Queue_decremented /= [] ->
         io:format("~n----------------------------~n"), 
         timer:sleep(1000),
         simulate_queue(Queue_decremented);
      true -> 
         io:format("There is no planes in the queue.~n"), 
         run()
   end
.



input_aircrafts(PID_ATC, PID_ATC_OBSERVER) ->
    
   {Mode, Name, Time, Delay} = input_aircraft_values(),
   PID_ATC ! {PID_ATC_OBSERVER, #plane{mode=Mode, name=Name, time=Time, delay=Delay}}.


exit() ->
   io:format("Program is going be down.\n"),
   init:stop(0).