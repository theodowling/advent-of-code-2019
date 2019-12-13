defmodule AdventOfCode.Day10Test do
  use ExUnit.Case

  import AdventOfCode.Day10
  doctest AdventOfCode.Day10

  # @tag :skip
  test "part1" do
    input = """
    .#..#
    .....
    #####
    ....#
    ...##
    """

    result = part1(input)

    assert result == "Best is {3, 4} with 8 other asteroids detected"
  end

  # @tag :skip
  test "part1.2" do
    input = """
    ......#.#.
    #..#.#....
    ..#######.
    .#.#.###..
    .#..#.....
    ..#....#.#
    #..#....#.
    .##.#..###
    ##...#..#.
    .#....####
    """

    result = part1(input)

    assert result == "Best is {5, 8} with 33 other asteroids detected"
  end

  # @tag :skip
  test "part1.3" do
    input = """
    #.#...#.#.
    .###....#.
    .#....#...
    ##.#.#.#.#
    ....#.#.#.
    .##..###.#
    ..#...##..
    ..##....##
    ......#...
    .####.###.
    """

    result = part1(input)

    assert result == "Best is {1, 2} with 35 other asteroids detected"
  end

  # @tag :skip
  test "part2" do
    input = """
    .#....#####...#..
    ##...##.#####..##
    ##...#...#.#####.
    ..#.....#...###..
    ..#.#.....#....##
    """

    result = part2(input, {8, 3})

    assert result ==
             [
               {8, 1},
               {9, 0},
               {9, 1},
               {10, 0},
               {9, 2},
               {11, 1},
               {12, 1},
               {11, 2},
               {15, 1},
               {12, 2},
               {13, 2},
               {14, 2},
               {15, 2},
               {12, 3},
               {16, 4},
               {15, 4},
               {10, 4},
               {8, 3},
               {4, 4},
               {2, 4},
               {2, 3},
               {0, 2},
               {1, 2},
               {0, 1},
               {1, 1},
               {5, 2},
               {1, 0},
               {5, 1},
               {6, 1},
               {6, 0},
               {7, 0},
               {8, 0},
               {10, 1},
               {14, 0},
               {16, 1},
               {13, 3},
               {14, 3}
             ]
  end
end
