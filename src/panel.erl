-module(panel).

-include("../include/records.hrl").

-export([main/0]).

-import(client,[request/5]).
-import(server,[start/0]).
-import(mock,[mock/2]).
-import(utils,[input_aircraft_values/0, input_mode/0, print_options/0, draw_aircraft/0]).


main() ->
   io:format("The airport traffic controll is ready to use.\n"),
   print_options(),   
   run().

run() ->
   Action = io:get_line("Choose action: "),
   if

      Action =:= "1\n" ->
      
         PID_ATC = spawn(server, atc, [[]]),             % nasluchuje na dodawanie samolotow do kolejki
         %PID_ATC_OBSERVER = spawn(panel, atc_observer, [PID_ATC]),   % nasluchuje na kolejke do wyswietlenia

         {ok, [X]} = io:fread("How many aircrafts? ", "~d"),
         mock(PID_ATC, X),

         PID_ATC ! {self(), release},
         receive
            {_, Queue} ->
               io:format("~n----------------------------~nSIMULATION:~n~n"),
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
   lists:foreach(
      fun(P = #plane{time=Time, name=Name}) ->
         case Time of
            0 ->
               io:format("Aircraft: ~s is leaving the runaway.~n", [Name]);
               
               % TODO: tylko jeden moze wylatywać, w tym czasie rośnie opóźnienie innym 
               %lists:foreach(
               %   fun(P_ = #plane{time=Time_, delay=Delay_}) when Time_==0 -> 
               %      P_#plane{delay=Delay_+1} 
               %   end, 
               %   Queue
               %);

            _ -> 
               io:format("~p~n", [P])
         end
      end,
      Queue
   ), 

   % jesli ktorys samolot ma time=-1 to usun go z listy
   Queue_filtered = lists:filter(fun(#plane{time=Time}) -> Time /= 0 end, Queue),

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
   end.


exit() ->
   io:format("Program is going be down.\n"),
   init:stop(0).