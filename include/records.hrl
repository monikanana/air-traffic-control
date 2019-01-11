% aircraft in the air
-record(air, {
    mode=land,
    name,
    time_to_land, % planowany czas do lądowania
    time_on_fuel,
    delay
}).

% aircraft on the ground
-record(ground, {
    mode=take_off,
    name,
    time_to_take_off,
    delay
}).

% aircraft in general
-record(plane, {
    mode,
    name,
    time,
    delay
}).

