defmodule AdventOfCode.Day5 do
  import Enum
  import AdventOfCode

  @doc """
  Solves part 1

  iex> AdventOfCode.Day5.solve_1("05_1_test")
  5

  """
  def solve_1(assignment \\ "05", only_cardinals \\ true) do
    input(assignment)
    |> remove_blanks
    |> map(&parse_input/1)
    |> map(& expand(&1, only_cardinals))
    |> List.flatten()
    |> reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1+1)) end)
    |> map(&(elem(&1,1)))
    |> filter(&(&1 > 1))
    |> count
  end

  def


  def solve_2(assignment \\ "05"), do: solve_1(assignment, false)

  def expand([from, to], mode), do: get_range(from, to, mode)

  @doc """

  iex> AdventOfCode.Day5.parse_input("0,1 -> 1,2")
  [{0,1}, {1,2}]
  """
  def parse_input(str) do
    Regex.run(~r/(\d+),(\d+) ?-> ?(\d+).(\d+)/, str)
    |> slice(1,4)
    |> map(&String.to_integer/1)
    |> chunk_every(2)
    |> map(&List.to_tuple/1)
  end

  @doc """
  Gets a range all coordinates in a list between the two points

  iex> AdventOfCode.Day5.get_range({0, 2}, {4,2}, true)
  [{0,2}, {1,2}, {2,2}, {3,2}, {4,2}]

  iex> AdventOfCode.Day5.get_range({2,0}, {2, 4}, true)
  [{2,0}, {2,1}, {2,2}, {2,3}, {2,4}]

  iex> AdventOfCode.Day5.get_range({1,1}, {3,3}, false)
  [{1,1}, {2,2}, {3,3}]

  iex> AdventOfCode.Day5.get_range({9,7}, {7,9}, false)
  [{9,7}, {8,8}, {7,9}]
  """
  def get_range({x, y}, {z, y}, true), do: map(x..z, &({&1, y}))
  def get_range({x, y}, {x, z}, true), do: map(y..z, &({x, &1}))
  def get_range(_, _, true), do: []
  def get_range({x,y}, {x,y}, false), do: [{x,y}]
  def get_range({x, y}, {a, d}, false) do
    [{x, y}] ++ get_range(
      {
        next_number(x, a),
        next_number(y, d)
      }, 
      {a, d},
      false
    )
  end
  def get_range(x, y) do
    IO.inspect([x,y])
    []
  end

  def next_number(x, y) when x < y, do: x + 1
  def next_number(x, y) when x > y, do: x - 1
  def next_number(x,x), do: x
end
