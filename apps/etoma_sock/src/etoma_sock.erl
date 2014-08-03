-module(etoma_sock).

-export([move_to/3, move_to/4, move_to/5]).
-export([cast/1, register/1, deregister/1]).
-export([now_in_msec/0]).

-define(PAD, 10).

register(Pid) ->
  gen_server:call(etoma_sock_event, {register, Pid}).

deregister(Pid) ->
  gen_server:call(etoma_sock_event, {deregister, Pid}).

move_to(Id, X, Y) ->
  move_to(Id, X, Y, now_in_msec() + ?PAD).

move_to(Id, X, Y, T) ->
  move_to(Id, X, Y, T, []).

move_to(Id, X, Y, T, P) ->
  Props = [{id, Id}, {t, T}, {x, X}, {y, Y}] ++ P,
  cast([{Props}]).

cast(Msg) ->
  gen_server:cast(etoma_sock_event, Msg).

now_in_msec() ->
  {Mega, Sec, Micro} = os:timestamp(),
  trunc(Mega * 1.0e9 + Sec * 1.0e3 + Micro * 1.0e-3).

