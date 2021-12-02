defmodule AdventOfCode.Day2 do
  import AdventOfCode
  import Enum

  @doc """

  iex> AdventOfCode.Day2.solve_1("02_1_test")
  150

  """
  def solve_1(assignment \\ "02") do
    input(assignment)
    |> reduce({0, 0}, &move(&1, &2))
    |> combine_position
  end

  @doc """

  iex> AdventOfCode.Day2.solve_2("02_2_test")
  900

  """

  def solve_2(assignment \\ "02") do
    input(assignment)
    |> reduce({0, 0, 0}, &move_aim(&1, &2))
    |> combine_position
  end

  @spec move_aim(<<_::24, _::_*8>>, {any, any, number}) :: {any, any, number}
  def move_aim("forward " <> distance, {x, y, aim}),
    do: {
      x + parseInt!(distance),
      y + parseInt!(distance) * aim,
      aim
    }

  def move_aim("down " <> distance, {x, y, aim}), do: {x, y, aim + parseInt!(distance)}
  def move_aim("up " <> distance, {x, y, aim}), do: {x, y, aim - parseInt!(distance)}

  def move("forward " <> distance, {x, y}), do: {x + parseInt!(distance), y}
  def move("down " <> distance, {x, y}), do: {x, y + parseInt!(distance)}
  def move("up " <> distance, {x, y}), do: {x, y - parseInt!(distance)}

  defp combine_position({x, y}), do: x * y
  defp combine_position({x, y, _}), do: x * y
end
