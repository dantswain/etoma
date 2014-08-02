-module(etoma_behavior).

-export([payload/0]).

-export([stationary/4,
         circular/4,
         linear/4,
         uniform_walk/4,
         normal_walk/4,
         compose/2
        ]).

-record(payload, {speed = 0,
                  omega = 0,
                  theta = 0,
                  pos_noise = 0}).

payload() -> #payload{}.

stationary(_Id, X, Y, P) -> {X, Y, P}.

circular(_Id, X, Y, P = #payload{speed = S, omega = O, theta = T}) ->
  {
    linear_x(X, S, T),
    linear_y(Y, S, T),
    P#payload{theta = T + O}
  }.

linear(_Id, X, Y, P = #payload{speed = S, theta = T}) ->
  {
    linear_x(X, S, T),
    linear_y(Y, S, T),
    P
  }.

uniform_walk(_Id, X, Y, P = #payload{pos_noise = N}) ->
  {
    X + math:sqrt(12.0) * N * uniform_noise(),
    Y + math:sqrt(12.0) * N * uniform_noise(),
    P
  }.

normal_walk(_Id, X, Y, P = #payload{pos_noise = N}) ->
  {
    X + math:sqrt(N) * normal_noise(),
    Y + math:sqrt(N) * normal_noise(),
    P
  }.

compose(B1, B2) ->
  fun(Id, X, Y, P) ->
      {X1, Y1, P1} = B1(Id, X, Y, P),
      B2(Id, X1, Y1, P1)
  end.

linear_x(X, S, T) ->
  X + S * math:cos(T).

linear_y(Y, S, T) ->
  Y + S * math:sin(T).

uniform_noise() ->
  random:uniform() - 0.5.

% naive-ish box-muller transform
normal_noise() ->
  U1 = random:uniform(),
  U2 = random:uniform(),
  math:sqrt(-2.0*math:log(U1)) * math:cos(2.0 * math:pi() * U2).
