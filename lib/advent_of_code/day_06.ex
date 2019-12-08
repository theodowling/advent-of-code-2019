defmodule AdventOfCode.Day06 do
  alias AdventOfCode.Utils.Input

  def part1(inputs) do
    inputs
    |> Input.parse_lines()
    |> Enum.reduce(%{}, fn a, acc ->
      [l, r] = String.split(a, ")")
      Map.update(acc, l, [r], &[r | &1])
    end)
    |> count_connections("COM", 1, 0)
  end

  def count_connections(_map, nil, _, acc), do: acc

  def count_connections(map, k, i, acc) do
    start = Map.get(map, k)

    if start != nil do
      Enum.reduce(start, acc, fn key, acc ->
        acc + i + count_connections(map, key, i + 1, 0)
      end)
    else
      acc
    end
  end

  def part2(inputs) do
    inputs
    |> Input.parse_lines()
    |> Enum.reduce(%{}, fn a, acc ->
      [l, r] = String.split(a, ")")
      Map.update(acc, l, [r], &[r | &1])
    end)
    |> map_routes("COM", "COM")
    |> List.flatten()
    |> find_san_and_you()
  end

  def map_routes(map, k, acc) do
    values = Map.get(map, k)

    if values != nil,
      do: Enum.map(values, fn v -> map_routes(map, v, "#{acc}:#{v}") end),
      else: acc
  end

  def find_san_and_you(list) do
    [a, b] =
      Enum.filter(list, fn x -> String.contains?(x, "YOU") or String.contains?(x, "SAN") end)
      |> Enum.map(fn x -> String.split(x, ":") end)

    a_map = MapSet.new(a)
    b_map = MapSet.new(b)

    unique_items = MapSet.union(MapSet.difference(a_map, b_map), MapSet.difference(b_map, a_map))
    MapSet.size(unique_items) - 2
  end
end
