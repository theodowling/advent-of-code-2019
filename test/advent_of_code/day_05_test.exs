defmodule AdventOfCode.Day05Test do
  use ExUnit.Case

  import AdventOfCode.Day05

  # @tag :skip
  test "part1" do
    # assert part2(
    #          "3,21,1008,21,8,20,1005,20,22,107,8,21,20,1006,20,31,1106,0,36,98,0,0,1002,21,125,20,4,20,1105,1,46,104,999,1105,1,46,1101,1000,1,20,4,20,1105,1,46,98,99"
    #        )

    assert part1("1,0,0,0,99") == "2,0,0,0,99"
    assert part1("1002,4,3,4,33") == "1002,4,3,4,99"
    assert part1("1101,100,-1,4,0") == "1101,100,-1,4,99"
    assert part1("2,3,0,3,99") == "2,3,0,6,99"
    assert part1("3,0,4,0,99") == "1,0,4,0,99"
    assert part1("2,4,4,5,99,0") == "2,4,4,5,99,9801"
    assert part1("1,1,1,4,99,5,6,0,99") == "30,1,1,4,2,5,6,0,99"
    assert part1("3,1,99") == "3,1,99"
    assert part1("3,2,99,0,0,0,99") == "6,2,1,0,0,0,99"
  end

  # @tag :skip
  test "part2" do
    # value should be 1
    assert part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", %{inputs: [1]})
    # # value should be 0
    assert part2("3,3,1105,-1,9,1101,0,0,12,4,12,99,1", %{inputs: [0]})
    # # value should be 0
    assert part2("3,12,6,12,15,1,13,14,13,4,13,99,-1,0,1,9", %{inputs: [0]})
  end
end
