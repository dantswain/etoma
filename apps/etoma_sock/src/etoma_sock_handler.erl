-module(etoma_sock_handler).
-behavior(cowboy_websocket_handler).

-export([init/3]).
-export([websocket_init/3]).
-export([websocket_handle/3]).
-export([websocket_info/3]).
-export([websocket_terminate/3]).

init({tcp, http}, _Req, _Opts) ->
  {upgrade, protocol, cowboy_websocket}.

websocket_init(_TransportName, Req, _Opts) ->
  gen_server:call(etoma_sock_event, {register, self()}),
  {ok, Req, undefined_state}.

websocket_handle(_Data, Req, State) ->
  {ok, Req, State}.

websocket_info({timeout, _Ref, Msg}, Req, State) ->
  {reply, {text, Msg}, Req, State};

websocket_info(Info, Req, State) ->
  {reply, {text, jiffy:encode(Info)}, Req, State}.

websocket_terminate(_Reason, _Req, _State) ->
  gen_server:call(etoma_sock_event, {deregister, self()}),
  ok.
