-module(etoma_fsm).

-behaviour(gen_fsm).

%% API
-export([start_link/5]).

%% gen_fsm callbacks
-export([init/1, step/2, step/3, handle_event/3,
         handle_sync_event/4, handle_info/3, terminate/3, code_change/4]).

-define(SERVER, ?MODULE).
-define(DT, 100).

-record(proc_state, {id, x, y, payload, step_callback}).

%%%===================================================================
%%% API
%%%===================================================================

start_link(Id, X0, Y0, CB, Payload) ->
  gen_fsm:start_link(?MODULE, [Id, X0, Y0, CB, Payload], []).

%%%===================================================================
%%% gen_fsm callbacks
%%%===================================================================

init([Id, X0, Y0, CB, Payload]) ->
  gproc:reg({n, l, {etoma, Id}}, etoma),
  {ok, step, #proc_state{id = Id, x = X0, y = Y0, step_callback = CB, payload = Payload}, ?DT}.

step(_Event, ProcState = #proc_state{id = Id, x = X, y = Y, payload = Payload, step_callback = CB}) ->
  {XNew, YNew, PayloadNew} = CB(Id, X, Y, Payload),
  etoma_sock:move_to(Id, X, Y, etoma_sock:now_in_msec() + 50),
  {next_state, step, ProcState#proc_state{x = XNew, y = YNew, payload = PayloadNew}, ?DT}.

step(_Event, _From, ProcState) ->
  Reply = ok,
  {reply, Reply, step, ProcState}.

handle_event(_Event, StateName, ProcState) ->
  {next_state, StateName, ProcState}.

handle_sync_event(get_position, _From, StateName, ProcState = #proc_state{x = X, y = Y}) ->
  {reply, {X, Y}, StateName, ProcState, 0};
handle_sync_event(get_payload, _From, StateName, ProcState = #proc_state{payload = P}) ->
  {reply, P, StateName, ProcState, 0};
handle_sync_event({set_position, X, Y}, _From, StateName, ProcState) ->
  {reply, ok, StateName, ProcState#proc_state{x = X, y = Y}, 0};
handle_sync_event({set_callback, NewCB}, _From, StateName, ProcState) ->
  {reply, ok, StateName, ProcState#proc_state{step_callback = NewCB}, 0};
handle_sync_event({set_payload, NewP}, _From, StateName, ProcState) ->
  {reply, ok, StateName, ProcState#proc_state{payload = NewP}, 0};

handle_sync_event(_Event, _From, StateName, ProcState) ->
  Reply = ok,
  {reply, Reply, StateName, ProcState}.

handle_info(_Info, StateName, ProcState) ->
  {next_state, StateName, ProcState}.

terminate(_Reason, _StateName, #proc_state{id = Id}) ->
  gproc:unreg({n, l, {etoma, Id}}),
  ok.

code_change(_OldVsn, StateName, ProcState, _Extra) ->
  {ok, StateName, ProcState}.

%%%===================================================================
%%% Internal functions
%%%===================================================================
