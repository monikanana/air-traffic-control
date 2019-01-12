-module(panel).

-include("../include/records.hrl").

-export([main/0]).

-import(client,[request/5]).
-import(server,[start/0]).


main() ->
   io:format("The airport traffic controll is ready to use.\n"),
   print_options(),   
   run().

run() ->
   Action = io:get_line(""),
   if
      Action =:= "1\n" ->
         io:format("wybrales 1\n"),
         run();

      Action =:= "2\n" ->
         Mode = land, Name = "Airbus A320", Time = 180, Delay = 0, %TODO: dane podawane z klawiatury

         PID_ATC = spawn(server, atc, [[]]),             % nasluchuje na dodawanie samolotow do kolejki
         PID_ATC_OBSERVER = spawn(fun atc_observer/0),   % nasluchuje na kolejke do wyswietlenia
         PID_ATC ! {PID_ATC_OBSERVER, {
            #plane{mode=Mode, name=Name, time=Time, delay=Delay}
         }},

         PID_ATC ! {PID_ATC_OBSERVER, release},
         run();
         
      Action =:= "8\n" ->
         print_options(),
         run();

      Action =:= "9\n" ->
         exit();

      true ->
         io:fwrite("Wrong action, try again. Use '8' to check all available option\n"),
         run()
   end.

atc_observer() ->
   receive
      {_, Queue} ->     % TODO: something is wrong with printing Queue
         io:format(Queue),
         atc_observer()
   end.

print_options() ->
   io:format("------------- MENU ---------------------------------\n"),
   io:format("Press 1 to simulate traffic with mock data.\n"),
   io:format("Press 2 to simulate traffic with your own airplanes.\n"),
   io:format("Press 8 to see menu.\n"),
   io:format("Press 9 to exit.\n"),
   io:format("------------- MENU ---------------------------------\n").

exit() ->
   io:format("Program is going be down.\n"),
   init:stop(0).