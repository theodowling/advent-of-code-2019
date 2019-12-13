defmodule Mix.Tasks.D12.P2 do
  use Mix.Task

  import AdventOfCode.Day12

  @shortdoc "Day 12 Part 2"
  def run(args) do
    input = """
    <x=14, y=4, z=5>
    <x=12, y=10, z=8>
    <x=1, y=7, z=-10>
    <x=16, y=-5, z=3>
    """

    if Enum.member?(args, "-b"),
      do: Benchee.run(%{part_2: fn -> input |> part2() end}),
      else:
        input
        |> part2()
        |> IO.inspect(label: "Part 2 Results")
  end
end
