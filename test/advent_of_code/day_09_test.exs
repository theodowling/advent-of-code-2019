defmodule AdventOfCode.Day09Test do
  use ExUnit.Case

  import AdventOfCode.Day09
  # doctest AdventOfCode.Day09

  # @tag :skip
  test "part1" do
    # assert part1("109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99")
    # assert part1("1102,34915192,34915192,7,4,7,99,0")
    # assert part1("104,1125899906842624,99")
    # outputs -1
    # assert part1("109,-1,4,1,99")
    # outputs 1
    # assert part1("109,-1,104,1,99")
    # outputs 109
    # assert part1("109,-1,204,1,99")
    # outputs 204
    # assert part1("109,1,9,2,204,-6,99")
    # outputs 204
    # assert part1("109,1,109,9,204,-6,99")
    # outputs 204
    # assert part1("109,1,209,-1,204,-106,99")
    # outputs the input
    # assert part1("109,1,3,3,204,2,99", %{inputs: [10]})
    # outputs the input
    # assert part1("109,1,203,2,204,2,99", %{inputs: [99]})
  end

  @tag :skip
  test "part2" do
    input = nil
    result = part2(input)

    assert result
  end
end
