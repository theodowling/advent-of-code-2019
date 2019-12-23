defmodule AdventOfCode.Day16 do
  @base_pattern [0, 1, 0, -1]

  @doc """
      iex> l = AdventOfCode.Day16.part1("80871224585914546619083218645595", 100)
      ...> String.length(l) == 8
      true
  """
  def part1(input, n \\ 100, print \\ false) do
    input
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> execute(n, print)
    |> Enum.join()
  end

  @doc """
      iex> AdventOfCode.Day16.execute([1,2,3,4,5,6,7,8], 1)
      [4,8,2,2,6,1,5,8]

      iex> AdventOfCode.Day16.execute([1,2,3,4,5,6,7,8], 2)
      [3,4,0,4,0,4,3,8]

      iex> AdventOfCode.Day16.execute([1,2,3,4,5,6,7,8], 4)
      [0,1,0,2,9,4,9,8]

      iex> AdventOfCode.Day16.execute([8,0,8,7,1,2,2,4,5,8,5,9,1,4,5,4,6,6,1,9,0,8,3,2,1,8,6,4,5,5,9,5], 100)
      [2,4,1,7,6,1,7,6]
  """
  def execute(list, n, print \\ false)

  def execute(list, n, _print) when n == 0, do: Enum.take(list, 8)

  def execute(list, n, print) do
    output =
      Enum.map(1..length(list), fn i ->
        repeating_pattern = repeating_pattern(i, length(list))

        Enum.zip(list, repeating_pattern)
        |> Enum.map(fn {item, pattern} ->
          item * pattern
        end)
      end)
      |> Enum.map(fn list ->
        abs(rem(Enum.sum(list), 10))
      end)

    if print, do: IO.inspect("At repeat #{n} value is #{Enum.join(output)}")

    execute(output, n - 1, print)
  end

  @doc """
      iex> AdventOfCode.Day16.repeating_pattern(2, 9)
      [0, 1, 1, 0, 0, -1, -1, 0, 0]

      iex> AdventOfCode.Day16.repeating_pattern(1, 8)
      [1, 0, -1, 0, 1, 0, -1, 0]

      iex> AdventOfCode.Day16.repeating_pattern(1, 7)
      [1, 0, -1, 0, 1, 0, -1]

      iex> AdventOfCode.Day16.repeating_pattern(3, 12)
      [0, 0, 1, 1, 1, 0, 0, 0, -1, -1, -1, 0]
  """
  def repeating_pattern(element, total) do
    repeated_pattern =
      Enum.map(@base_pattern, fn b ->
        for _ <- 1..element do
          b
        end
      end)
      |> List.flatten()

    repeat_count = div(total + 1, length(repeated_pattern)) + 1

    for _ <- 1..repeat_count do
      repeated_pattern
    end
    |> List.flatten()
    |> Enum.take(total + 1)
    |> Enum.drop(1)
  end

  def solve(input) do
    sum = input |> Enum.sum()

    {0, numbers} =
      Enum.reduce(input, {sum, []}, fn n, {sum, acc} ->
        {sum - n, [Integer.mod(sum, 10) | acc]}
      end)

    numbers |> Enum.reverse()
  end

  @doc """
      iex> AdventOfCode.Day16.part2("03036732577212944063491565474664")
      "84462026"
  """
  def part2(input_text) do
    input =
      input_text
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))

    input = 1..10000 |> Stream.flat_map(fn _ -> input end)
    offset = input |> Enum.take(7) |> Integer.undigits()
    input = input |> Enum.drop(offset)

    1..100
    |> Enum.reduce(input, fn _, input -> solve(input) end)
    |> Enum.take(8)
    |> Enum.map(&to_string/1)
    |> Enum.join("")
  end
end
