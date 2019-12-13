defmodule AdventOfCode.Day12Test do
  use ExUnit.Case

  import AdventOfCode.Day12
  doctest AdventOfCode.Day12

  # @tag :skip
  test "part1.1" do
    input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    result = part1(input, 10)

    assert result == 179
  end

  # @tag :skip
  test "part1.2" do
    input = """
    <x=-8, y=-10, z=0>
    <x=5, y=5, z=10>
    <x=2, y=-7, z=3>
    <x=9, y=-8, z=-3>
    """

    result = part1(input, 100)

    assert result == 1940
  end

  # @tag :skip
  test "part2" do
    input = """
    <x=-1, y=0, z=2>
    <x=2, y=-10, z=-7>
    <x=4, y=-8, z=8>
    <x=3, y=5, z=-1>
    """

    result = part2(input)

    assert result == 2772
  end
end
