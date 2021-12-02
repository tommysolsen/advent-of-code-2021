defmodule AdventOfCode.Day1 do
  @doc """

  iex> AdventOfCode.Day1.solve_1("01_1_test")
  7

  """
  def solve_1(assignment \\ "01") do
    AdventOfCode.input(assignment)
    |> AdventOfCode.as_ints()
    |> count_increases()
  end

  @doc """

  iex> AdventOfCode.Day1.solve_2("01_2_test")
  5
  """
  def solve_2(assignment \\ "01") do
    AdventOfCode.input(assignment)
    |> AdventOfCode.as_ints()
    |> create_triple_measurement()
    |> count_increases()
  end

  defp create_triple_measurement(data, sums \\ [])

  defp create_triple_measurement([x, y, z | tail], sums),
    do: create_triple_measurement([y] ++ [z] ++ tail, sums ++ [x + y + z])

  defp create_triple_measurement(_, sums), do: sums

  defp count_increases(base, value \\ nil, count \\ 0)
  defp count_increases([x | tail], nil, count), do: count_increases(tail, x, count)

  defp count_increases([x | tail], value, count)
       when x > value,
       do: count_increases(tail, x, count + 1)

  defp count_increases([x | tail], _, count), do: count_increases(tail, x, count)
  defp count_increases([], _, count), do: count
end
