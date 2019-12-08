defmodule AdventOfCode.Day08 do
  @doc """
      iex> AdventOfCode.Day08.parse("123456789012", 3, 2)
      [[[1, 2, 3], [4, 5, 6]], [[7, 8, 9], [0, 1, 2]]]
  """

  def parse(input, width, height) do
    input
    |> String.trim("\n")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.chunk_every(width * height)
    |> Enum.map(&Enum.chunk_every(&1, width))
  end

  def part1(input, width, height) do
    input
    |> String.trim("\n")
    |> String.split("", trim: true)
    |> Enum.map(&String.to_integer(&1))
    |> Enum.chunk_every(width * height)
    |> Enum.min_by(fn layer -> Enum.count(layer, fn pixel -> pixel == 0 end) end)
    |> (fn layer ->
          Enum.count(layer, fn pixel -> pixel == 1 end) *
            Enum.count(layer, fn pixel -> pixel == 2 end)
        end).()
  end

  @doc """

      iex> AdventOfCode.Day08.inspect_pixels("0222112222120000", 2, 2, false)
      [0, 1, 1, 0]
  """

  def inspect_pixels(input, x, y, print \\ true) do
    image =
      input
      |> String.trim("\n")
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer(&1))
      |> Enum.chunk_every(x * y)
      |> calculate_image(nil, x * y)

    if print, do: print_image(image, x, y)

    image
  end

  def calculate_image([top_layer | rest], nil, n), do: calculate_image(rest, top_layer, n)
  def calculate_image([], image, _), do: image

  def calculate_image([layer | rest], image, n) do
    new_image =
      for i <- 0..(n - 1) do
        if Enum.at(image, i) == 2 do
          Enum.at(layer, i)
        else
          Enum.at(image, i)
        end
      end

    calculate_image(rest, new_image, n)
  end

  def print_image(pixels, x, _y) do
    Enum.chunk_every(pixels, x)
    |> Enum.map(&Enum.join(&1, ""))
    |> Enum.each(&IO.puts(&1))
  end

  def part2(input, x, y) do
    inspect_pixels(input, x, y, true)
  end
end
