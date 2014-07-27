-module(etoma_sock_event).
-behavior(gen_server).

-export([init/1, handle_cast/2, terminate/2]).
-export([code_change/3, handle_call/3, handle_info/2]).

-define(HEARTBEAT, 1000).

init(_Args) ->
  start_tic(self()),
  {ok, []}.

handle_call({register, Pid}, _From, Pids) ->
  {reply, ok, lists:concat([Pids, [Pid]])};

handle_call({deregister, Pid}, _From, Pids) ->
  {reply, ok, lists:delete(Pid, Pids)};

handle_call(_, _, S) ->
   {reply, ok, S}.

handle_info({timeout, _Timer, tic}, Pids) ->
  send_heartbeat(Pids),
  start_tic(self()),
  {noreply, Pids};

handle_info(_, S) ->
  {noreply, S}.

handle_cast(Msg, Pids) ->
  send_all(Msg, Pids),
  {noreply, Pids}.

terminate(_Args, _State) ->
    ok.

code_change(_, S, _) ->
  {ok, S}.

start_tic(Pid) ->
  erlang:start_timer(?HEARTBEAT, Pid, tic).

send_heartbeat(Pids) ->
  send_all({[{tic, etoma_sock:now_in_msec()}]}, Pids).

send_all(Msg, Pids) ->
  lists:foreach(fun(Pid) -> Pid ! Msg end, Pids).
