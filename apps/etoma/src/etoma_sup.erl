-module(etoma_sup).

-behaviour(supervisor).

%% API
-export([start_link/0, start_child/5]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).

start_child(Id, X0, Y0, CB, Payload) ->
  supervisor:start_child(?MODULE, [Id, X0, Y0, CB, Payload]).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  EtomaFSM = {etoma_fsm, {etoma_fsm, start_link, []},
    temporary, brutal_kill, worker, [etoma_fsm]},
  Children = [EtomaFSM],
  {ok, {{simple_one_for_one, 1, 100}, Children}}.
