defmodule AdventOfCode.Utils.Input do
  @spec parse_lines(binary) :: [binary]
  def parse_lines(input) do
    input |> String.split("\n", trim: true)
  end

  def comma_separated_integers(input) do
    input |> String.split(",", trim: true) |> Enum.map(&String.to_integer(&1))
  end

  def comma_separated(input) do
    input |> String.split(",", trim: true)
  end
end
