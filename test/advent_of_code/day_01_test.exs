defmodule AdventOfCode.Day01Test do
  use ExUnit.Case
  doctest AdventOfCode.Day01

  import AdventOfCode.Day01

  # @tag :skip
  test "part1" do
    input = """
    12
    14
    1969
    100756
    """

    result = part1(input)

    assert result == 34_241
  end

  # @tag :skip
  test "part2" do
    input = "14"
    result = part2(input)
    assert result == 2

    input = "1969"
    result = part2(input)
    assert result == 966

    input = "100756"
    result = part2(input)
    assert result == 50346
  end
end
