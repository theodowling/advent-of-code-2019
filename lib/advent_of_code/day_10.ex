defmodule AdventOfCode.Day10 do
  require IEx

  def part1(input) do
    asteroids = input |> parse_grid()
    points = MapSet.to_list(asteroids)

    {k, v} =
      Enum.reduce(points, %{}, fn point, acc ->
        Map.put(
          acc,
          point,
          Enum.filter(points, fn b -> line_of_sight(point, b, asteroids) end)
          |> Enum.count()
        )
      end)
      |> Enum.max_by(fn {_, v} -> v end)

    "Best is #{inspect(k)} with #{v} other asteroids detected"
  end

  @doc """
      iex> line_of_sight({0, 2}, {4, 4}, MapSet.new([{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]))
      true

      iex> line_of_sight({1, 0}, {4, 4}, MapSet.new([{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]))
      true

      iex> line_of_sight({4, 3}, {4, 4}, MapSet.new([{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]))
      true

      iex> line_of_sight({1, 2}, {3, 2}, MapSet.new([{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]))
      false
  """

  def line_of_sight(a, b, _) when a == b, do: false

  def line_of_sight(a, b, asteroids) do
    coordinates_to_check = whole_integer_interception_points(a, b)
    MapSet.intersection(coordinates_to_check, asteroids) == MapSet.new([])
  end

  @doc """

  ## Examples

      iex> AdventOfCode.Day10.parse_grid(\"""
      ...> .#..#
      ...> .....
      ...> #####
      ...> ....#
      ...> ...##
      ...> \""")
      #MapSet<[{0, 2}, {1, 0}, {1, 2}, {2, 2}, {3, 2}, {3, 4}, {4, 0}, {4, 2}, {4, 3}, {4, 4}]>
  """

  def parse_grid(input) do
    rows =
      input
      |> String.split("\n", trim: true)

    y_nr = Enum.count(rows) - 1

    x_nr =
      rows
      |> Enum.at(0)
      |> String.split("", trim: true)
      |> Enum.count()
      |> (fn count -> count - 1 end).()

    rows
    |> Enum.map(&String.split(&1, "", trim: true))
    |> List.flatten()
    |> add_coordinates([], x_nr, y_nr, 0, 0)
    |> MapSet.new()
  end

  def add_coordinates([], acc, _, _, _, _), do: Enum.reverse(acc)

  def add_coordinates(items, acc, x_nr, y_nr, x, y) when x > x_nr,
    do: add_coordinates(items, acc, x_nr, y_nr, 0, y + 1)

  def add_coordinates([h | rest], acc, x_nr, y_nr, x, y) when h == "#",
    do: add_coordinates(rest, [{x, y} | acc], x_nr, y_nr, x + 1, y)

  def add_coordinates([_ | rest], acc, x_nr, y_nr, x, y),
    do: add_coordinates(rest, acc, x_nr, y_nr, x + 1, y)

  @doc """

      iex> AdventOfCode.Day10.whole_integer_interception_points({1,1}, {3,5})
      #MapSet<[{2, 3}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({3,5}, {1,1})
      #MapSet<[{2, 3}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({1,1}, {5,5})
      #MapSet<[{2, 2}, {3, 3}, {4, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({1,1}, {5,6})
      #MapSet<[]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({1,0}, {3,4})
      #MapSet<[{2, 2}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({4, 4}, {4, 0})
      #MapSet<[{4, 1}, {4, 2}, {4, 3}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({4, 4}, {0, 4})
      #MapSet<[{1, 4}, {2, 4}, {3, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({5,1}, {5,5})
      #MapSet<[{5, 2}, {5, 3}, {5, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({5,5}, {5,1})
      #MapSet<[{5, 2}, {5, 3}, {5, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({5,3}, {3,5})
      #MapSet<[{4, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({2,2}, {4,6})
      #MapSet<[{3, 4}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({0,2}, {2,0})
      #MapSet<[{1, 1}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({0,2}, {4,4})
      #MapSet<[{2, 3}]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({4, 3}, {4, 4})
      #MapSet<[]>

      iex> AdventOfCode.Day10.whole_integer_interception_points({1, 2}, {3, 2})
      #MapSet<[{2, 2}]>

  """

  def whole_integer_interception_points({x1, y1}, {x2, y2}) when x1 > x2,
    do: whole_integer_interception_points({x2, y2}, {x1, y1})

  def whole_integer_interception_points({x1, y1}, {x2, y2}) when x1 == x2 do
    range =
      if y2 >= y1 do
        (y1 + 1)..(y2 - 1)
      else
        (y2 + 1)..(y1 - 1)
      end

    range
    |> Enum.map(fn y -> {x1, y} end)
    |> MapSet.new()
    |> MapSet.delete({x1, y1})
    |> MapSet.delete({x2, y2})
  end

  def whole_integer_interception_points({x1, y1}, {x2, y2}) do
    delta_y = y2 - y1
    delta_x = x2 - x1

    y_step = delta_y / delta_x

    if gcd(delta_x, delta_y) != 1 do
      1..(delta_x - 1)
      |> Enum.map(fn x_change ->
        if round(y1 + y_step * x_change) == y1 + y_step * x_change do
          {x1 + x_change, round(y1 + y_step * x_change)}
        end
      end)
      |> Enum.filter(&(&1 != nil))
    else
      []
    end
    |> MapSet.new()
    |> MapSet.delete({x1, y1})
    |> MapSet.delete({x2, y2})
  end

  def gcd(a, 0), do: abs(a)
  def gcd(a, b), do: gcd(b, rem(a, b))

  def part2(input, {x0, y0} = base, number \\ nil) do
    asteroids = input |> parse_grid()
    points = MapSet.to_list(asteroids)

    angles_to_points =
      Enum.reduce(points, %{}, fn point, acc ->
        angle = angle_between(base, point)
        Map.update(acc, angle, [point], &[point | &1])
      end)
      |> Enum.to_list()
      |> Enum.sort(fn {key1, _}, {key2, _} -> key1 < key2 end)

    angles_to_points =
      Enum.map(angles_to_points, fn {k, v} ->
        {k, Enum.sort_by(v, fn {x1, y1} -> distance_between_points({x0, y0}, {x1, y1}) end)}
      end)
      |> Enum.reverse()

    kill_order = shoot_points(angles_to_points, base, [])

    if number do
      {x, y} = Enum.at(kill_order, number - 1)
      x * 100 + y
    else
      kill_order
    end
  end

  def shoot_points([], _, acc),
    do: Enum.reverse(acc)

  def shoot_points([{_angle, []} | rest], {x0, y0}, acc),
    do: shoot_points(rest, {x0, y0}, acc)

  def shoot_points([{angle, [target | next]} | rest], {x0, y0}, acc) do
    new_angles = rest ++ [{angle - 360, next}]
    shoot_points(new_angles, {x0, y0}, [target | acc])
  end

  def distance_between_points({x1, y1}, {x2, y2}) do
    :math.sqrt(:math.pow(x2 - x1, 2) + :math.pow(y2 - y1, 2))
  end

  @doc """

      iex> AdventOfCode.Day10.angle_between({0, 0}, {1, 1})
      45.0

      iex> AdventOfCode.Day10.angle_between({0, 0}, {1, -1})
      135.0

      iex> AdventOfCode.Day10.angle_between({0, 0}, {0, -1})
      180.0

      iex> AdventOfCode.Day10.angle_between({0, 0}, {-1, -1}) + 360
      225.0

      iex> AdventOfCode.Day10.angle_between({0, 0}, {-1, 1}) + 360
      315.0
  """

  @spec angle_between({number, number}, {number, number}) :: float
  def angle_between({x1, y1}, {x2, y2}) do
    # https://en.wikipedia.org/wiki/Atan2
    # https://www.mathworks.com/matlabcentral/answers/87591-change-the-zero-angle-of-the-atan2-or-similar
    :math.atan2(x2 - x1, y2 - y1) * 180 / :math.pi()
  end
end
