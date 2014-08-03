# Etoma

Erlang automata playground with websocket-driven visualization

## Quick start

This project uses [rebar](https://github.com/basho/rebar) to manage dependencies and compile.

```bash
./rebar get-deps
./rebar compile
./rebar generate
rel/etoma/bin/etoma console
```

Then point your browser at [http://localhost:8080/](http://localhost:8080/).  Note, if you modify
any of the javascript files (in apps/etoma_sock/priv), you can copy them to the built release
(without having to completely recompile and build) by running `rake static`.

Create an object with `id = 0` at `(x,y) = (100, 100)` with a circular behavior
via the erlang console:

```erlang
(etoma@127.0.0.1)1> etoma:new(0, 100, 100, etoma_behavior:circular(5, 0.25)).
{ok,<0.1176.0>}
```

Change the behavior of the object to add noise by first getting the behavior and
then composing it with a noise generator:

```erlang
(etoma@127.0.0.1)2> {ok, C} = etoma:get_behavior(0).
{ok,#Fun<etoma_behavior.1.102839409>}
(etoma@127.0.0.1)3> NoisyCircle = etoma_behavior:compose(C, etoma_behavior:normal_walk(5)).
#Fun<etoma_behavior.5.102839409>
(etoma@127.0.0.1)4> etoma:change_behavior(0, NoisyCircle).
ok
```

Stop the object by replacing its behavior with a stationary function:

```erlang
(etoma@127.0.0.1)5> etoma:change_behavior(0, etoma_behavior:stationary()).
ok
```

## Background

The basic websocket framework is taken from the [Cowboy](https://github.com/extend/cowboy)
[websocket example](https://github.com/extend/cowboy/tree/master/examples/websocket).
Animation is via [Paper.js](http://paperjs.org).

I built this project to explore using Erlang to program simple dynamic objects, with the
idea that each object would be an Erlang process and that "behavior" would be defined by
functions and modifyable using ideas from functional programming.
