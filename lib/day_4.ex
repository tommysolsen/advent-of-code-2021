defmodule AdventOfCode.Day4 do
  import AdventOfCode
  import Enum

  @doc """

  iex> AdventOfCode.Day4.solve_1("04_1_test")
  4512
  """
  def solve_1(assignment \\ "04") do
    {drawn_numbers, boards} = parse_input(assignment)
    solve_1(drawn_numbers, boards, 5)
  end

  defp solve_1([], _, _), do: throw("no winners")

  defp solve_1([x | tail], boards, size) do
    boards = map(boards, &pick_number(&1, x))

    winner = find(boards, nil, &has_been_solved(&1, size))

    case winner do
      nil -> solve_1(tail, boards, size)
      board -> sum_non_selected_numbers(board) * x
    end
  end

  @doc """

  iex> AdventOfCode.Day4.solve_2("04_1_test")
  1924
  """
  def solve_2(assignment \\ "04") do
    {drawn_numbers, boards} = parse_input(assignment)
    solve_2(drawn_numbers, boards, 5)
  end

  def solve_2([], _, _), do: throw("multiple candidates still exists")
  def solve_2(_, [], _size), do: throw("Went too far")

  def solve_2([x | tail], [board] = boards, size) do
    [board] = map(boards, &pick_number(&1, x))

    if(has_been_solved(board, size)) do
      sum_non_selected_numbers(board) * x
    else
      solve_2(tail, [board], size)
    end
  end

  def solve_2([x | tail], boards, size) do
    boards = map(boards, &pick_number(&1, x))

    case reject(boards, &has_been_solved(&1, size)) do
      [board] ->
        solve_2(tail, [board], size)

      boards ->
        solve_2(tail, boards, size)
    end
  end

  @doc """
  iex> AdventOfCode.Day4.sum_non_selected_numbers([[{1, true}, {2, true}, {3, true}, {4, false}, {5, false}], [{6, false}, {7, true}, {23, true}, {4, false}, {24, true}]])
  19
  """
  @spec sum_non_selected_numbers([{number, boolean}]) :: number
  def sum_non_selected_numbers(board),
    do:
      reduce(board, 0, fn row, acc ->
        reduce(row, acc, fn
          {_, true}, acc -> acc
          {v, false}, acc -> acc + v
        end)
      end)

  @doc """

  Pick number

   iex> AdventOfCode.Day4.pick_number([[{1, false}, {2, false}, {3, false}, {4, false}, {5, true}], [{6, false}, {7, false}, {23, false}, {4, false}, {24, false}]], 23)
   [[{1, false}, {2, false}, {3, false}, {4, false}, {5, true}], [{6, false}, {7, false}, {23, true}, {4, false}, {24, false}]]
  """
  def pick_number(board, number),
    do:
      map(board, fn row ->
        map(row, fn
          {n, false} when n == number ->
            {n, true}

          x ->
            x
        end)
      end)

  @doc """

  Checks if a board has been solved

  iex> AdventOfCode.Day4.has_been_solved([[{22, false}, {13, false}, {17, false}, {11, false}, {0, false}],[{8, false}, {2, false}, {23, false}, {4, false}, {24, false}],[{21, false}, {9, true}, {14, false}, {16, false}, {7, false}],[{6, false}, {10, false}, {3, false}, {18, true}, {5, false}],[{1, false}, {12, false}, {20, false}, {15, false}, {19, false}]], 5)
  false

  It can detect rows
  iex> AdventOfCode.Day4.has_been_solved([[{22, false}, {13, false}, {17, false}, {11, false}, {0, false}], [{8, false}, {2, false}, {23, false}, {4, false}, {24, false}], [{21, false}, {9, false}, {14, false}, {16, false}, {7, false}], [{6, true}, {10, true}, {3, true}, {18, true}, {5, true}], [{1, false}, {12, false}, {20, false}, {15, false}, {19, false}]], 5)
  true

   It can detect columns
  iex> AdventOfCode.Day4.has_been_solved([[{22, false}, {13, true}, {17, false}, {11, false}, {0, false}], [{8, false}, {2, true}, {23, true}, {4, false}, {24, false}], [{21, false}, {9, true}, {14, false}, {16, false}, {7, false}], [{6, false}, {10, true}, {3, false}, {18, false}, {5, false}], [{1, false}, {12, true}, {20, false}, {15, false}, {19, false}]], 5)
  true



  """
  def has_been_solved(board, b_size) do
    test_cols(board, b_size) || test_rows(board, b_size)
  end

  def test_cols(board, b_size) do
    0..(b_size - 1)
    |> map(&col(board, &1))
    |> map(&group_is_true/1)
    |> member?(true)
  end

  def test_rows(board, b_size) do
    0..(b_size - 1)
    |> map(&row(board, &1))
    |> map(&group_is_true/1)
    |> member?(true)
  end

  def test_diagonals(board, b_size) do
    d1 =
      board
      |> diagonal(b_size, &top_bottom/2)
      |> group_is_true()

    d2 =
      board
      |> diagonal(b_size, &bottom_top/2)
      |> group_is_true()

    d1 || d2
  end

  def group_is_true([]), do: true
  def group_is_true([{_, false} | _]), do: false
  def group_is_true([{_, true} | tail]), do: group_is_true(tail)

  def diagonal(board, size, direction, i \\ 0, results \\ [])

  def diagonal([], _, _, _, results), do: results

  def diagonal([row | tail], size, direction, i, results),
    do: diagonal(tail, size, direction, i + 1, results ++ [at(row, direction.(i, size))])

  def top_bottom(i, _size), do: i
  @spec bottom_top(number, number) :: number
  def bottom_top(i, size), do: size - 1 - i

  @doc """
  iex> AdventOfCode.Day4.col([[22, 13, 17, 11, 0], [8, 2, 23, 4, 24], [21, 9, 14, 16, 7], [6, 10, 3, 18, 5], [1, 12, 20, 15, 19]],1)
  [13, 2, 9, 10, 12]

  """
  def col(board, col) do
    map(board, &at(&1, col))
  end

  def add_picked_state(x), do: {x, false}

  @doc """

  iex> AdventOfCode.Day4.row([[22, 13, 17, 11, 0], [8, 2, 23, 4, 24], [21, 9, 14, 16, 7], [6, 10, 3, 18, 5], [1, 12, 20, 15, 19]],1)
  [8,2,23,4,24]

  """
  def row(board, col) do
    at(board, col)
  end

  defp get_boards([]), do: []
  defp get_boards(["" | tail]), do: get_boards(tail)

  defp get_boards([x | tail]),
    do:
      [
        String.split(x, ~r/\W+/)
        |> map(&String.to_integer/1)
      ] ++
        get_boards(tail)

  defp get_drawn_numbers([x | tail]),
    do: {
      x
      |> String.split(",")
      |> map(&String.to_integer/1),
      tail
    }

  defp parse_input(assignment) do
    {drawn_numbers, board_data} =
      input(assignment)
      |> get_drawn_numbers()

    boards =
      get_boards(board_data)
      |> map(fn x ->
        map(x, &add_picked_state/1)
      end)
      |> chunk_every(5)

    {drawn_numbers, boards}
  end
end
