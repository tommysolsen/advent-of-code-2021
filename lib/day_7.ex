defmodule AdventOfCode.Day7 do
  import AdventOfCode
  import Enum

  @doc """

  iex> AdventOfCode.Day7.solve_1("07_1_test")
  37
  """
  def solve_1(assignment \\ "07") do
    data = parse_input(assignment)

    Enum.min(data)..Enum.max(data)
    |> reduce(nil, fn
      i, nil ->
        reduce(data, 0, &(&2 + diff(&1, i)))

      i, acc ->
        Kernel.min(acc, reduce(data, 0, &(&2 + diff(&1, i))))
    end)
  end

  @doc """

  iex> AdventOfCode.Day7.solve_2("07_1_test")
  168
  """
  def solve_2(assignment \\ "07") do
    data = parse_input(assignment)

    Enum.min(data)..Enum.max(data)
    |> reduce(nil, fn
      i, nil ->
        reduce(data, 0, &(&2 + surging_diff(&1, i)))

      i, acc ->
        Kernel.min(acc, reduce(data, 0, &(&2 + surging_diff(&1, i))))
    end)
  end

  def surging_diff(x, y, cost \\ 1)

  def surging_diff(x, x, _), do: 0
  def surging_diff(x, y, cost) when x < y, do: cost + surging_diff(x + 1, y, cost + 1)
  def surging_diff(x, y, cost) when x > y, do: cost + surging_diff(x - 1, y, cost + 1)

  def diff(x, y), do: abs(x - y)

  @doc """

  AdventOfCode.Day7.parse_input("07_1_test")
  [16,1,2,0,4,2,7,1,2,14]
  """
  def parse_input(assignment) do
    input(assignment)
    |> at(0)
    |> String.split(~r/\D+/)
    |> as_ints()
  end
end
