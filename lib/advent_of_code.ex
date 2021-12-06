defmodule AdventOfCode do
  import Enum

  @moduledoc """
  Documentation for `AdventOfCode`.
  """
  def input(id) do
    File.read!("./inputs/" <> id <> ".txt")
    |> String.split("\n")
    |> map(&String.trim/1)
    |> filter(&(!!&1))
  end

  def remove_blanks(lines), do: filter(lines, &(&1 != ""))
  def as_ints(list), do: map(list, &Integer.parse/1) |> map(&elem(&1, 0))

  def parseInt!(v), do: elem(Integer.parse(v), 0)

  defp extract_number({x, ""}), do: x
end
