-module(utils).
-export([input_aircraft_values/0, input_mode/0, print_options/0]).

input_aircraft_values() ->
   {
      input_mode(),
      binary_to_list(iolist_to_binary(re:replace(io:get_line("Name: "), "\n", ""))), 
      erlang:list_to_integer(binary_to_list(iolist_to_binary(re:replace(io:get_line("Time: "), "\n", "")))), 
      erlang:list_to_integer(binary_to_list(iolist_to_binary(re:replace(io:get_line("Delay: "), "\n", ""))))
   }.

input_mode() ->
   io:format("[1] Landing [2] Taking off: "), Option = io:get_line(""),
   if Option =:= "1\n" -> land;
      Option =:= "2\n" -> take_off;
      true -> io:format("Incorrect option.\n"), input_mode()
   end.

print_options() ->
   io:format("------------- MENU ---------------------------------\n"),
   io:format("Press 1 to simulate traffic with mock data.\n"),
   io:format("Press 2 to simulate traffic with your own airplanes.\n"),
   io:format("Press 8 to see menu.\n"),
   io:format("Press 9 to exit.\n"),
   io:format("------------- MENU ---------------------------------\n").
