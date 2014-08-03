-module(etoma).

-export([
         new/3,
         new/4,
         new/5,
         get_position/1,
         get_payload/1,
         set_position/3,
         set_payload/2,
         change_behavior/2,
         get_behavior/1
        ]).

new(Id, X, Y) ->
  new(Id, X, Y, etoma_behavior:stationary(), etoma_behavior:payload()).

new(Id, X, Y, Callback) ->
  new(Id, X, Y, Callback, etoma_behavior:payload()).

new(Id, X, Y, Callback, Payload) ->
  etoma_sup:start_child(Id, X, Y, Callback, Payload).

get_position(Id) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, get_position).

get_payload(Id) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, get_payload).

set_position(Id, X, Y) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, {set_position, X, Y}).

set_payload(Id, P) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, {set_payload, P}).

change_behavior(Id, NewCB) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, {set_callback, NewCB}).

get_behavior(Id) ->
  Pid = gproc:where({n, l, {etoma, Id}}),
  gen_fsm:sync_send_all_state_event(Pid, get_callback).
