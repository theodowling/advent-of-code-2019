defmodule AdventOfCode.Day04 do
  @spec part1(Range.t()) :: non_neg_integer
  def part1(min..max) do
    Enum.count(min..max, &valid_password(&1))
  end

  @spec part2(Range.t()) :: non_neg_integer
  def part2(min..max) do
    Enum.count(min..max, &valid_password2(&1))
  end

  @doc """

      iex> AdventOfCode.Day04.valid_password(111111)
      true

      iex> AdventOfCode.Day04.valid_password(223450)
      false

      iex> AdventOfCode.Day04.valid_password(123789)
      false
  """
  @spec valid_password(integer()) :: true | false
  def valid_password(password) do
    {true, password}
    |> digits_increasing?()
    |> contains_double?()
    |> (fn {outcome, _} -> outcome end).()
  end

  @spec digits_increasing?({boolean(), integer()}) :: {true, any} | {false, any}
  def digits_increasing?({_, password}) do
    not_valid =
      password
      |> Integer.digits()
      |> (fn digits -> decreasing(digits) end).()

    {not not_valid, password}
  end

  defp decreasing([a, b | _rest]) when a > b, do: true
  defp decreasing([_, _b | []]), do: false

  defp decreasing([_, b | rest]) do
    decreasing([b | rest])
  end

  @spec contains_double?({false, integer()} | {true, integer()}) ::
          {false, integer()} | {true, integer()}
  def contains_double?({false, password}), do: {false, password}

  def contains_double?({true, password}) do
    unique_count =
      password
      |> Integer.digits()
      |> Enum.dedup()
      |> Enum.count()

    {unique_count < 6, password}
  end

  @spec contains_special_double?({false, integer()} | {true, integer()}) ::
          {false, integer()} | {true, integer()}
  def contains_special_double?({false, password}), do: {false, password}

  def contains_special_double?({true, password}) do
    valid =
      password
      |> Integer.digits()
      |> Enum.reverse()
      |> check_for_doubles?()

    {valid, password}
  end

  @spec frequencies(list()) :: map()
  def frequencies(str) do
    Enum.reduce(str, Map.new(), fn c, acc -> Map.update(acc, c, 1, &(&1 + 1)) end)
  end

  @spec check_for_doubles?(list()) :: boolean
  def check_for_doubles?(str) do
    Enum.any?(frequencies(str), fn {_, v} -> v == 2 end)
  end

  @doc """

      iex> AdventOfCode.Day04.valid_password2(112233)
      true

      iex> AdventOfCode.Day04.valid_password2(123444)
      false

      iex> AdventOfCode.Day04.valid_password2(111122)
      true

      iex> AdventOfCode.Day04.valid_password2(111226)
      true

      iex> AdventOfCode.Day04.valid_password2(112345)
      true

      iex> AdventOfCode.Day04.valid_password2(115556)
      true
  """

  @spec valid_password2(integer()) :: true | false
  def valid_password2(password) do
    {true, password}
    |> digits_increasing?()
    |> contains_special_double?()
    |> (fn {outcome, _} -> outcome end).()
  end
end
