-module(etoma_behavior).

-export([payload/0]).

-export([stationary/4,
         circular/4,
         linear/4]).

-record(payload, {speed, omega, theta}).

payload() -> #payload{}.

stationary(_Id, X, Y, P) -> {X, Y, P}.

circular(_Id, X, Y, P = #payload{speed = S, omega = O, theta = T}) ->
  {
    X + S * math:cos(T),
    Y + S * math:sin(T),
    P#payload{theta = T + O}
  }.

linear(Id, X, Y, P) ->
  circular(Id, X, Y, P#payload{omega = 0}).
