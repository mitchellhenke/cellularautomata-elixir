# CellularAutomata
Cellular Automata represented as Elixir Processes.

Reference: [http://rosettacode.org/wiki/One-dimensional_cellular_automata#Elixir](http://rosettacode.org/wiki/One-dimensional_cellular_automata#Elixir)

```elixir
# helper to generate N cells with random status:
list = CellularAutomata.make_list(20)
# Print status of each cell:
Enum.map(list, fn(x) -> CellularAutomata.get_status(x) end)
# => [0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 0, 1, 0, 0, 0]
# "Evolving" a generation currently involves getting evolution of every cell,
# and then setting each one:
Enum.map(list, fn(x) -> CellularAutomata.evolve(x) end)
|> Enum.zip(list)
|> Enum.each(fn({new_status, cell}) -> CellularAutomata.set_status(cell, new_status) end)
# => :ok

# Print statuses of new generation:
Enum.map(list, fn(x) -> CellularAutomata.get_status(x) end)
# => [0, 1, 0, 1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 0]
```
