defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Utils.Input

  def part1(input) do
    inputs = Input.parse(input)

    Enum.map(inputs, fn mass ->
      fuel_required(mass)
    end)
    |> Enum.sum()
  end

  def part2(input) do
    inputs = Input.parse(input)

    Enum.map(inputs, fn mass ->
      total_fuel_required(mass, 0)
    end)
    |> Enum.sum()
  end

  @doc """
  ## Example

      iex> AdventOfCode.Day01.fuel_required("12")
      2
      iex> AdventOfCode.Day01.fuel_required("14")
      2
      iex> AdventOfCode.Day01.fuel_required("1969")
      654
      iex> AdventOfCode.Day01.fuel_required("100756")
      33583
  """
  def fuel_required(mass_string) when is_binary(mass_string) do
    mass_string
    |> String.to_integer()
    |> fuel_required()
  end

  def fuel_required(mass_string) when is_number(mass_string) do
    mass_string
    |> div(3)
    |> (fn a -> a - 2 end).()
  end

  def total_fuel_required(mass_string, acc) do
    fr = fuel_required(mass_string)

    if fr > 0 do
      total_fuel_required(fr, fr + acc)
    else
      acc
    end
  end
end
