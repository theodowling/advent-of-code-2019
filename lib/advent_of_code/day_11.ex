defmodule AdventOfCode.Day11 do
  import AdventOfCode.Utils.Intcode
  alias AdventOfCode.Utils.Input
  alias AdventOfCode.Utils.Intcode.State

  def part1(input, state \\ %{}) do
    list =
      input
      |> Input.comma_separated_integers()

    updated_state = Map.merge(%State{}, state)

    updated_program =
      list
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Enum.into(%{})

    get_output(updated_program, 0, updated_state, {0, 0, :up}, %{{0, 0} => false}) |> Enum.count()
  end

  def get_output(program, pos, state, {x, y, _} = coords, map) do
    if program[pos] == 99 do
      IO.inspect("terminating")
      map
    else
      {p, ps, s} = run(program, pos, state)

      if program[pos] == 3 do
        [left_ind, paint_ind] = s.outputs
        white = paint_ind == 1
        left = left_ind == 1
        updated_map = Map.put(map, {x, y}, white)
        {new_x, new_y, new_direction} = turn_left(left, coords)
        next_input = if updated_map[{new_x, new_y}], do: 1, else: 0
        updated_state = s |> Map.put(:inputs, [next_input]) |> Map.put(:outputs, [])
        get_output(p, ps, updated_state, {new_x, new_y, new_direction}, updated_map)
      else
        IO.inspect(program[pos])
      end
    end
  end

  def part2(input, state \\ %{}) do
    list =
      input
      |> Input.comma_separated_integers()

    updated_state = Map.merge(%State{}, state)

    updated_program =
      list
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Enum.into(%{})

    map = get_output(updated_program, 0, updated_state, {50, 5, :up}, %{{50, 5} => true})
    {{x1, _}, {x2, _}} = Enum.min_max_by(map |> Map.keys(), fn {x, _} -> x end)
    {{_, y1}, {_, y2}} = Enum.min_max_by(map |> Map.keys(), fn {_, y} -> y end)

    [{x1, x2}, {y1, y2}]

    for y <- y2..y1 do
      for x <- x2..x1 do
        if map[{x, y}] do
          "⬜"
        else
          " "
        end
      end
      |> Enum.join("")
    end
    |> Enum.join("\n")
    |> IO.puts()
  end

  def turn_left(true, {x, y, :up}), do: {x - 1, y, :left}
  def turn_left(false, {x, y, :up}), do: {x + 1, y, :right}
  def turn_left(true, {x, y, :left}), do: {x, y - 1, :down}
  def turn_left(false, {x, y, :left}), do: {x, y + 1, :up}
  def turn_left(true, {x, y, :down}), do: {x + 1, y, :right}
  def turn_left(false, {x, y, :down}), do: {x - 1, y, :left}
  def turn_left(true, {x, y, :right}), do: {x, y + 1, :up}
  def turn_left(false, {x, y, :right}), do: {x, y - 1, :down}
end
