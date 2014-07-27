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

Then point your browser at [http://localhost:8080/](http://localhost:8080/).

Place an object at `(x,y) = (100, 100)` via the erlang console:

```
(etoma@127.0.0.1)1> etoma_sock:move_to(0, 100, 100).
ok
```


## Background

The basic websocket framework is taken from the [Cowboy](https://github.com/extend/cowboy)
[websocket example](https://github.com/extend/cowboy/tree/master/examples/websocket).
