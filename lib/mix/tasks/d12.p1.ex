defmodule Mix.Tasks.D12.P1 do
  use Mix.Task

  import AdventOfCode.Day12

  @shortdoc "Day 12 Part 1"
  def run(args) do
    input = """
    <x=14, y=4, z=5>
    <x=12, y=10, z=8>
    <x=1, y=7, z=-10>
    <x=16, y=-5, z=3>
    """

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_1: fn -> input |> part1(1000) end}),
      else:
        input
        |> part1(1000)
        |> IO.inspect(label: "Part 1 Results")
  end
end
