defmodule Mix.Tasks.GetSolution do
  use Mix.Task

  def run(["1", day]) do
    input = String.pad_leading(day, 2, <<"0">>)
    atom = String.to_atom("Elixir.AdventOfCode.Day" <> day)

    apply(atom, :solve_1, [input])
    |> IO.inspect()
  end

  def run(["2", day]) do
    input = String.pad_leading(day, 2, <<"0">>)
    atom = String.to_atom("Elixir.AdventOfCode.Day" <> day)

    apply(atom, :solve_2, [input])
    |> IO.inspect()
  end

  def run(_), do: IO.puts("Supply first the solution number then day")
end
