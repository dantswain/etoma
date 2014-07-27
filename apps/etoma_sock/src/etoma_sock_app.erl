-module(etoma_sock_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, _StartArgs) ->
  Dispatch = cowboy_router:compile(
               [
                {'_', [
                       {"/", cowboy_static, {priv_file, etoma_sock, "index.html"}},
                       {"/index.html", cowboy_static, {priv_file, etoma_sock, "index.html"}},
                       {"/websocket", etoma_sock_handler, []},
                       {"/static/[...]", cowboy_static, {priv_dir, etoma_sock, "static"}}
                      ]}
               ]),
  {ok, _} = cowboy:start_http(http, 100, [{port, 8080}],
                              [{env, [{dispatch, Dispatch}]}]),

  etoma_sock_sup:start_link().

stop(_State) ->
  ok.
