defmodule AdventOfCode.Utils.Input do
  @spec parse(binary) :: [binary]
  def parse(input) do
    input |> String.split("\n", trim: true)
  end
end
