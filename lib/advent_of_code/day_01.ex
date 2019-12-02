defmodule AdventOfCode.Day01 do
  alias AdventOfCode.Utils.Input

  @spec part1(binary) :: number()
  def part1(input) do
    inputs = Input.parse(input)

    Enum.map(inputs, fn mass ->
      fuel_required(mass)
    end)
    |> Enum.sum()
  end

  @spec part2(binary) :: number()
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
  @spec fuel_required(binary) :: number
  def fuel_required(mass_string) when is_binary(mass_string) do
    mass_string
    |> String.to_integer()
    |> fuel_required()
  end

  @spec fuel_required(number()) :: number
  def fuel_required(mass_string) when is_number(mass_string) do
    mass_string
    |> div(3)
    |> (fn a -> a - 2 end).()
  end

  @spec total_fuel_required(binary() | number(), number()) :: number()
  def total_fuel_required(mass_string, acc) do
    fr = fuel_required(mass_string)

    if fr > 0 do
      total_fuel_required(fr, fr + acc)
    else
      acc
    end
  end
end
