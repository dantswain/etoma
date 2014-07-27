-module(etoma_sock_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

%% Helper macro for declaring children of supervisor
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).

%% ===================================================================
%% API functions
%% ===================================================================

start_link() ->
  supervisor:start_link({local, ?MODULE}, ?MODULE, []).

%% ===================================================================
%% Supervisor callbacks
%% ===================================================================

init([]) ->
  EtomaSockEvent = {etoma_sock_event,
                {gen_server, start_link, [{local, etoma_sock_event}, etoma_sock_event, [], []]},
                permanent, 1000, worker, [etoma_sock_event]},
  {ok, { {one_for_one, 5, 10}, [EtomaSockEvent]} }.

