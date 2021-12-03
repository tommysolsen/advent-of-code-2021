defmodule AdventOfCode.Day3 do
  import AdventOfCode
  import Enum

  @doc """

  iex> AdventOfCode.Day3.solve_1("03_1_test")
  198

  """
  def solve_1(assignment) do
    ch_input = input(assignment)

    byte_length =
      ch_input
      |> map(&String.length/1)
      |> max()

    epsilon =
      bit_selector(ch_input, byte_length, fn
        {zeros, ones} when zeros > ones -> "1"
        {_, _} -> "0"
      end)

    gamma =
      bit_selector(ch_input, byte_length, fn
        {zeros, ones} when ones > zeros -> "1"
        _ -> "0"
      end)

    String.to_integer(epsilon, 2) * String.to_integer(gamma, 2)
  end

  def bit_selector(input, size, selector) do
    0..(size - 1)
    |> reduce("", fn i, acc ->
      acc <> selector.(reduce(input, {0, 0}, &update_count(&2, String.at(&1, i))))
    end)
  end

  @doc """

  iex> AdventOfCode.Day3.solve_2("03_1_test")
  230
  """
  def solve_2(assignment \\ "03") do
    ch_input = input(assignment)

    [&oxygen_bit_resolver/1, &co2_bit_resolver/1]
    |> map(&filter_by_position(ch_input, &1))
    |> map(&String.to_integer(&1, 2))
    |> reduce(1, &*/2)
  end

  defp filter_by_position(input, predicate, pos \\ 0)

  defp filter_by_position([x], _, _), do: x

  defp filter_by_position(input, predicate, pos) do
    proms = get_prominents_for_pos(input, pos)

    filter(input, &has_number_in_pos(&1, pos, predicate.(proms)))
    |> filter_by_position(predicate, pos + 1)
  end

  defp has_number_in_pos(input, pos, val), do: String.at(input, pos) == val

  defp get_prominents_for_pos(input, pos),
    do:
      map(input, &split_into_bits/1)
      |> map(&Enum.at(&1, pos))
      |> group_by(& &1)
      |> map(&count(elem(&1, 1)))
      |> List.to_tuple()

  defp oxygen_bit_resolver({x, y}) when x > y, do: "0"
  defp oxygen_bit_resolver({x, x}), do: "1"
  defp oxygen_bit_resolver(_), do: "1"

  defp co2_bit_resolver({x, y}) when x <= y, do: "0"
  defp co2_bit_resolver({x, x}), do: "0"
  defp co2_bit_resolver(_), do: "1"

  defp split_into_bits(number), do: String.split(number, "") |> filter(&(&1 != ""))

  defp update_count({nils, ones}, "0"), do: {nils + 1, ones}
  defp update_count({nils, ones}, "1"), do: {nils, ones + 1}
end
