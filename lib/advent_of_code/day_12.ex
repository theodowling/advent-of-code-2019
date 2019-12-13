defmodule AdventOfCode.Day12 do
  @spec part1(binary, integer()) :: any
  def part1(input, steps) do
    %{"x" => x, "y" => y, "z" => z} = parse_positions(input)

    task_x = Task.async(fn -> iterate(x, steps) end)
    task_y = Task.async(fn -> iterate(y, steps) end)
    task_z = Task.async(fn -> iterate(z, steps) end)

    updated_x = Task.await(task_x)
    updated_y = Task.await(task_y)
    updated_z = Task.await(task_z)

    [{x1, xv1}, {x2, xv2}, {x3, xv3}, {x4, xv4}] = updated_x
    [{y1, yv1}, {y2, yv2}, {y3, yv3}, {y4, yv4}] = updated_y
    [{z1, zv1}, {z2, zv2}, {z3, zv3}, {z4, zv4}] = updated_z

    (abs(x1) + abs(y1) + abs(z1)) * (abs(xv1) + abs(yv1) + abs(zv1)) +
      (abs(x2) + abs(y2) + abs(z2)) * (abs(xv2) + abs(yv2) + abs(zv2)) +
      (abs(x3) + abs(y3) + abs(z3)) * (abs(xv3) + abs(yv3) + abs(zv3)) +
      (abs(x4) + abs(y4) + abs(z4)) * (abs(xv4) + abs(yv4) + abs(zv4))
  end

  @doc """
      iex> AdventOfCode.Day12.parse_positions(\"""
      ...> <x=2, y=-10, z=-7>
      ...> <x=-1, y=0, z=2>
      ...> <x=3, y=5, z=-1>
      ...> <x=4, y=-8, z=8>
      ...> \""")
      %{"x" => [{4, 0}, {3, 0}, {-1, 0}, {2, 0}], "y" => [{-8, 0}, {5, 0}, {0, 0}, {-10, 0}], "z" => [{8, 0}, {-1, 0}, {2, 0}, {-7, 0}]}
  """

  @spec parse_positions(binary) :: any
  def parse_positions(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [[_, x, y, z]] = Regex.scan(~r/<x=([\-0-9]+), y=([\-0-9]+), z=([\-0-9]+)>/, line)

      acc
      |> Map.update("x", [{String.to_integer(x), 0}], &[{String.to_integer(x), 0} | &1])
      |> Map.update("y", [{String.to_integer(y), 0}], &[{String.to_integer(y), 0} | &1])
      |> Map.update("z", [{String.to_integer(z), 0}], &[{String.to_integer(z), 0} | &1])
    end)
  end

  def iterate(moons, n), do: iterate(moons, n, 0)

  def iterate(moons, total, n) when n == total, do: moons

  def iterate(moons, total, n) do
    iterate(
      update_positions_and_velocities(moons),
      total,
      n + 1
    )
  end

  def update_positions_and_velocities([{a1, v1}, {a2, v2}, {a3, v3}, {a4, v4}]) do
    [new_v1, new_v2, new_v3, new_v4] =
      calculate_velocities({a1, v1}, {a2, v2}, {a3, v3}, {a4, v4})

    [
      {a1 + new_v1, new_v1},
      {a2 + new_v2, new_v2},
      {a3 + new_v3, new_v3},
      {a4 + new_v4, new_v4}
    ]
  end

  def find_repeat(moons), do: find_repeat(moons, MapSet.new([moons]), 0)

  def find_repeat(moons, state, n) do
    updated_state = update_positions_and_velocities(moons)
    # IO.inspect(updated_state, label: "Updated State")
    # IO.inspect(state, label: "state")

    if MapSet.member?(state, updated_state) do
      n + 1
    else
      find_repeat(updated_state, MapSet.put(state, updated_state), n + 1)
    end
  end

  @spec calculate_velocities(
          {integer, number},
          {integer, number},
          {integer, number},
          {integer, number}
        ) :: [number, ...]
  def calculate_velocities({a1, v1}, {a2, v2}, {a3, v3}, {a4, v4}) do
    [
      v1 + comp(a1, a2) + comp(a1, a3) + comp(a1, a4),
      v2 + comp(a2, a1) + comp(a2, a3) + comp(a2, a4),
      v3 + comp(a3, a1) + comp(a3, a2) + comp(a3, a4),
      v4 + comp(a4, a1) + comp(a4, a2) + comp(a4, a3)
    ]
  end

  @spec comp(integer, integer) :: -1 | 0 | 1
  def comp(a, b) when a < b, do: 1
  def comp(a, b) when a == b, do: 0
  def comp(a, b) when a > b, do: -1

  def part2(input) do
    %{"x" => x, "y" => y, "z" => z} = parse_positions(input)

    task_x = Task.async(fn -> find_repeat(x) end)
    task_y = Task.async(fn -> find_repeat(y) end)
    task_z = Task.async(fn -> find_repeat(z) end)

    updated_x = Task.await(task_x)
    updated_y = Task.await(task_y)
    updated_z = Task.await(task_z)

    # IO.inspect([{updated_x, updated_y, updated_z}])
    lcm(lcm(updated_x, updated_y), updated_z)
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))
  def lcm(a, b), do: div(abs(a * b), gcd(a, b))
end
