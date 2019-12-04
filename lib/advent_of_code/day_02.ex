defmodule AdventOfCode.Day02 do
  alias AdventOfCode.Utils.Input

  @spec part1(binary) :: binary
  def part1(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    list
    |> perform_actions(1, list)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end

  @spec perform_actions(list(), integer(), list()) :: any
  def perform_actions([99 | _rest], _count, list), do: list

  def perform_actions([], _count, list), do: list

  def perform_actions([1, a, b, c | rest], count, list) do
    updated_list = List.update_at(list, c, fn _ -> Enum.at(list, a) + Enum.at(list, b) end)

    rest =
      if c >= count * 4 do
        List.update_at(rest, c - count * 4, fn _ -> Enum.at(list, a) + Enum.at(list, b) end)
      else
        rest
      end

    perform_actions(rest, count + 1, updated_list)
  end

  def perform_actions([2, a, b, c | rest], count, list) do
    updated_list = List.update_at(list, c, fn _ -> Enum.at(list, a) * Enum.at(list, b) end)

    rest =
      if c >= count * 4 do
        List.update_at(rest, c - count * 4, fn _ -> Enum.at(list, a) * Enum.at(list, b) end)
      else
        rest
      end

    perform_actions(rest, count + 1, updated_list)
  end

  @spec part2(binary) :: {integer(), integer()}
  def part2(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    test_perform_actions(1, 1, list)
  end

  @spec test_perform_actions(integer(), integer(), [integer]) :: {integer, integer}
  def test_perform_actions(100, b, list), do: test_perform_actions(1, b + 1, list)
  def test_perform_actions(_, 100, _list), do: raise("crap")

  def test_perform_actions(a, b, list) do
    a_list =
      list
      |> List.update_at(1, fn _ -> a end)
      |> List.update_at(2, fn _ -> b end)

    if a_list |> perform_actions(1, a_list) |> Enum.at(0) == 19_690_720 do
      {a, b}
    else
      test_perform_actions(a + 1, b, list)
    end
  end
end
