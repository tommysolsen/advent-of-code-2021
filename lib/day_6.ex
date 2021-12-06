defmodule AdventOfCode.Day6 do
  import AdventOfCode
  import Enum

  @doc """

  iex> AdventOfCode.Day6.solve_1("06_1_test")
  5934
  """
  def solve_1(assignment \\ "06") do
    parsed_input(assignment)
    |> simulate_set(80)
    |> prepare_results()
  end

  defp add(x), do: &(&1 + x)

  def simulate_set(input, 0), do: input

  def simulate_set(input, x) when x > 0 do
    simulate_set(
      reduce(input, %{}, fn
        {0, x}, acc ->
          acc
          |> Map.update(6, x, add(x))
          |> Map.update(8, x, add(x))

        {x, y}, acc ->
          Map.update(acc, x - 1, y, add(y))
      end),
      x - 1
    )
  end

  @doc """

  @tag timeout: :infinity
  xiex> AdventOfCode.Day6.solve_2("06_1_test")
  26984457539
  """
  def solve_2(assignment \\ "06") do
    parsed_input(assignment)
    |> simulate_set(256)
    |> prepare_results()
  end

  defp prepare_results(results), do: Map.values(results) |> sum

  defp parsed_input(assignment),
    do:
      input(assignment)
      |> at(0)
      |> String.split(~r/\D+/)
      |> as_ints()
      |> reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
end
