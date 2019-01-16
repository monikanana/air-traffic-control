-module(utils).
-export([print_options/0, draw_aircraft/0, input_number/0]).


input_number() ->
   Answer = io:get_line("How many aircrafts? "),
   {X, _} = string:to_integer(Answer),
   case X of
      error -> 
         io:format("It should be a number.\n"),
         input_number();
      _ -> 
         X
      end.


print_options() ->
   io:format("------------- MENU --------------------------\n"),
   io:format("[1] simulate traffic with mock data.\n"),
   io:format("[8] see menu.\n"),
   io:format("[9] exit.\n"),
   io:format("------------- MENU --------------------------\n").


draw_aircraft() ->
   io:format("                             |\n"),
   io:format("                       --====|====--\n"),
   io:format("                             |  \n"),
   io:format("\n"),
   io:format("                         .-'''''-. \n"),
   io:format("                       .'_________'. \n"),
   io:format("                      /_/_|__|__|_\\_\\ \n"),
   io:format("                     ;'-._       _.-';\n"),
   io:format(",--------------------|    `-. .-'    |--------------------,\n"),
   io:format(" ``""--..__    ___     ;       '       ;   ___    __..--''`\n"),
   io:format("           `'-// \\\\.._\\             /_..// \\\\-'`\n"),
   io:format("              \\\\_//    '._       _.'    \\\\_//\n"),
   io:format("               `'`        ``---``        `'`\n").