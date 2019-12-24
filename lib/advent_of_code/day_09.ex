defmodule AdventOfCode.Day09 do
  import AdventOfCode.Utils.Intcode
  alias AdventOfCode.Utils.Input

  def part1(input, state \\ %{}) do
    list =
      input
      |> Input.comma_separated_integers()

    list
    |> run(state)
  end

  def part2(input, state \\ %{}) do
    list =
      input
      |> Input.comma_separated_integers()

    list
    |> run(state)
  end
end
