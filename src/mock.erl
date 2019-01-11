-module(mock).
-export([mock/0]).

mock() ->
    Aircrafts = ["Airbus A320", "Airbus A300", "Airbus A310", "Airbus A330", "Airbus A340", "Airbus A350", "Airbus A380",
                 "Boeing 747", "Boeing 747-400", "Boeing 747-8", "Boeing 767", "Boeing 777", "Boeing 787"],
    Mode = [land, take_off],
    {
        lists:nth(rand:uniform(length(Mode)), Mode),
        lists:nth(rand:uniform(length(Aircrafts)), Aircrafts),
        floor(rand:uniform()*100)+50,
        floor(rand:uniform()*100)-70
    }.