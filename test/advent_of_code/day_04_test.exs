defmodule AdventOfCode.Day04Test do
  use ExUnit.Case
  doctest AdventOfCode.Day04
  import AdventOfCode.Day04

  # @tag :skip
  test "part1" do
    result = part1(111_111..111_121)
    assert result == 9
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
