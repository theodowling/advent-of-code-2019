defmodule AdventOfCode.Day05 do
  alias AdventOfCode.Utils.Input
  import AdventOfCode.Utils.Intcode

  @spec part1(binary) :: binary
  def part1(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    original_length = length(list)

    list
    |> run(%{inputs: [1]})
    |> IO.inspect()
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.take(original_length)
    |> Enum.join(",")
  end

  @spec part2(binary, map()) :: binary
  def part2(integers, state \\ %{}) do
    list =
      integers
      |> Input.comma_separated_integers()

    state =
      if Map.has_key?(state, :inputs) do
        state
      else
        Map.put(state, :inputs, [5])
      end

    list
    |> run(state)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end
end
