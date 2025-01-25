# TA

Package with the following Technical Indicators (TA) implemented in Elixir and using Explorer as a dependency to handle data:

- SMA
- EMA
- RSI
- StochasticRSI
- MACD
- IMACD
- SMMA
- ZLEMA

## Installation

Tthe package can be installed by adding `ta` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ta, git: "https://github.com/alkufurado/ta", tag: "0.1.0"}
  ]
end
```

## 

Tests can be run by using `mix` in a shell:

`mix test`

## TODO

- [ ] Split the code so each indicator is in its own file
- [ ] Add code documentation
- [ ] Add usage examples
- [ ] Add more tests
