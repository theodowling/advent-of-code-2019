defmodule AdventOfCode.Day03 do
  import AdventOfCode.Utils.Input

  @spec part1({binary, binary}) :: number
  def part1({a, b}) do
    a_steps = comma_separated(a)
    b_steps = comma_separated(b)

    {step_through_a, _, _} =
      Enum.reduce(a_steps, {%{}, {0, 0}, 1}, fn step, {acc, pos, n} ->
        take_step(acc, pos, step, n)
      end)

    {step_through_b, _, _} =
      Enum.reduce(b_steps, {%{}, {0, 0}, 1}, fn step, {acc, pos, n} ->
        take_step(acc, pos, step, n)
      end)

    {x, y} =
      calculate_intersections(step_through_a, step_through_b)
      |> Enum.min_by(fn {a, b} -> abs(a) + abs(b) end)

    abs(x) + abs(y)
  end

  @spec calculate_intersections(map, map) :: MapSet.t(any)
  def calculate_intersections(a, b) do
    a_keys = Map.keys(a) |> MapSet.new()
    b_keys = Map.keys(b) |> MapSet.new()

    MapSet.intersection(a_keys, b_keys)
  end

  @doc """

      iex> AdventOfCode.Day03.take_step(%{}, {0, 0}, "U2", 0)
      {%{{0,1} => 1, {0, 2} => 2}, {0, 2}, 2}

      iex> AdventOfCode.Day03.take_step(%{{0,1} => 1, {0, 2} => 2}, {0, 2}, "U2", 2)
      {%{{0,1} => 1, {0, 2} => 2, {0, 3} => 3, {0, 4} => 4}, {0, 4}, 4}

      iex> AdventOfCode.Day03.take_step(%{{0,1} => 1, {0, 2} => 2}, {0, 2}, "R2", 2)
      {%{{0,1} => 1, {0, 2} => 2, {1, 2} => 3, {2, 2} => 4}, {2, 2}, 4}
  """
  def take_step(acc, {x, y}, "U" <> step, n) do
    count = String.to_integer(step)

    {acc, n} =
      Enum.reduce(1..count, {acc, n}, fn c, {acc, n} ->
        {Map.update(acc, {x, y + c}, n + 1, fn v -> v end), n + 1}
      end)

    {acc, {x, y + count}, n}
  end

  def take_step(acc, {x, y}, "D" <> step, n) do
    count = String.to_integer(step)

    {acc, n} =
      Enum.reduce(1..count, {acc, n}, fn c, {acc, n} ->
        {Map.update(acc, {x, y - c}, n + 1, fn v -> v end), n + 1}
      end)

    {acc, {x, y - count}, n}
  end

  def take_step(acc, {x, y}, "L" <> step, n) do
    count = String.to_integer(step)

    {acc, n} =
      Enum.reduce(1..count, {acc, n}, fn c, {acc, n} ->
        {Map.update(acc, {x - c, y}, n + 1, fn v -> v end), n + 1}
      end)

    {acc, {x - count, y}, n}
  end

  def take_step(acc, {x, y}, "R" <> step, n) do
    count = String.to_integer(step)

    {acc, n} =
      Enum.reduce(1..count, {acc, n}, fn c, {acc, n} ->
        {Map.update(acc, {x + c, y}, n + 1, fn v -> v end), n + 1}
      end)

    {acc, {x + count, y}, n}
  end

  @spec part2({binary, binary}) :: number()
  def part2({a, b}) do
    a_steps = comma_separated(a)
    b_steps = comma_separated(b)

    # determine coordtinates taken by rope a
    {step_through_a, _, _} =
      Enum.reduce(a_steps, {%{}, {0, 0}, 0}, fn step, {acc, pos, n} ->
        take_step(acc, pos, step, n)
      end)

    # determine coordtinates taken by rope b
    {step_through_b, _, _} =
      Enum.reduce(b_steps, {%{}, {0, 0}, 0}, fn step, {acc, pos, n} ->
        take_step(acc, pos, step, n)
      end)

    {_, a} =
      calculate_intersections(step_through_a, step_through_b)
      |> Enum.map(fn coord -> {coord, step_through_a[coord] + step_through_b[coord]} end)
      |> Enum.min_by(fn {_, v} -> v end)

    a
  end
end
