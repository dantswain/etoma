-module(etoma_behavior).

-export([payload/0]).

-export([stationary/0,
         circular/2,
         linear/1,
         uniform_walk/1,
         normal_walk/1,
         compose/2
        ]).

-record(payload, {theta = 0}).

payload() -> #payload{}.

stationary() -> fun(_Id, X, Y, P) -> {X, Y, P} end.

circular(S, O) ->
  fun(_Id, X, Y, P = #payload{theta = T}) ->
      {
       linear_x(X, S, T),
       linear_y(Y, S, T),
       P#payload{theta = T + O}
      }
  end.

linear(S) ->
  fun(_Id, X, Y, P = #payload{theta = T}) ->
      {
       linear_x(X, S, T),
       linear_y(Y, S, T),
       P
      }
  end.

uniform_walk(N) ->
  fun(_Id, X, Y, P) ->
      {
       X + math:sqrt(12.0) * math:sqrt(N) * uniform_noise(),
       Y + math:sqrt(12.0) * math:sqrt(N) * uniform_noise(),
       P
      }
  end.

normal_walk(N) ->
  fun(_Id, X, Y, P) ->
      {
       X + math:sqrt(N) * normal_noise(),
       Y + math:sqrt(N) * normal_noise(),
       P
      }
  end.

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
