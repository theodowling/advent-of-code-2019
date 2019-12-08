defmodule AdventOfCode.Day05 do
  alias AdventOfCode.Utils.Input

  @spec part1(binary) :: binary
  def part1(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    list
    |> new_perform_actions(0)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end

  @spec new_perform_actions(list(), integer()) :: any
  def new_perform_actions(list, pos) when pos > length(list), do: list

  def new_perform_actions(list, pos) do
    perform_action(Enum.at(list, pos), list, pos)
  end

  @spec perform_action(integer(), list(), integer()) :: list()
  def perform_action(99, list, _pos), do: list

  def perform_action(1, list, pos) do
    [1, a, b, c] = Enum.slice(list, pos, 4)
    IO.inspect({[1, a, b, c], list, pos})
    updated_list = List.update_at(list, c, fn _ -> Enum.at(list, a) + Enum.at(list, b) end)
    new_perform_actions(updated_list, pos + 4)
  end

  def perform_action(2, list, pos) do
    [2, a, b, c] = Enum.slice(list, pos, 4)
    IO.inspect({[2, a, b, c], list, pos})
    updated_list = List.update_at(list, c, fn _ -> Enum.at(list, a) * Enum.at(list, b) end)
    new_perform_actions(updated_list, pos + 4)
  end

  def perform_action(3, list, pos) do
    [3, a] = Enum.slice(list, pos, 2)
    IO.inspect({[3, a], list, pos})
    n = IO.gets("Input parameter\n")
    updated_list = List.update_at(list, a, fn _ -> String.to_integer(String.trim(n)) end)
    new_perform_actions(updated_list, pos + 2)
  end

  def perform_action(4, list, pos) do
    [4, a] = Enum.slice(list, pos, 2)
    IO.inspect({[4, a], list, pos})
    IO.inspect("Outputting value: #{Enum.at(list, a)}")
    new_perform_actions(list, pos + 2)
  end

  def perform_action(5, list, pos) do
    [5, a, b] = Enum.slice(list, pos, 3)
    IO.inspect({[5, a, b], list, pos})

    if Enum.at(list, a) != 0 do
      new_perform_actions(list, Enum.at(list, b))
    else
      new_perform_actions(list, pos + 3)
    end
  end

  def perform_action(6, list, pos) do
    [6, a, b] = Enum.slice(list, pos, 3)
    IO.inspect({[6, a, b], list, pos})

    if Enum.at(list, a) == 0 do
      new_perform_actions(list, Enum.at(list, b))
    else
      new_perform_actions(list, pos + 3)
    end
  end

  def perform_action(7, list, pos) do
    [7, a, b, c] = Enum.slice(list, pos, 4)
    IO.inspect({[7, a, b, c], list, pos})

    updated_list =
      if Enum.at(list, a) < Enum.at(list, b) do
        List.update_at(list, c, fn _ -> 1 end)
      else
        List.update_at(list, c, fn _ -> 0 end)
      end

    new_perform_actions(updated_list, pos + 4)
  end

  def perform_action(8, list, pos) do
    [8, a, b, c] = Enum.slice(list, pos, 4)
    IO.inspect({[8, a, b, c], list, pos})

    updated_list =
      if Enum.at(list, a) == Enum.at(list, b) do
        List.update_at(list, c, fn _ -> 1 end)
      else
        List.update_at(list, c, fn _ -> 0 end)
      end

    new_perform_actions(updated_list, pos + 4)
  end

  def perform_action(parameter, list, pos) when parameter > 99 do
    action = rem(parameter, 100)

    IO.inspect({parameter, list, pos})

    n =
      cond do
        action in [3, 4] -> 2
        action in [5, 6] -> 3
        true -> 4
      end

    case n do
      2 ->
        [_parameter, a] = Enum.slice(list, pos, 2)

        updated_list =
          case action do
            3 ->
              IO.inspect("Updating with: 1")
              List.update_at(list, a, fn _ -> 1 end)

            4 ->
              IO.inspect("Outputting value: #{Enum.at(list, a)}")
              list
          end

        new_perform_actions(updated_list, pos + 2)

      3 ->
        [parameter, a, b] = Enum.slice(list, pos, 3)
        a_val = if rem(div(parameter, 100), 10) == 1, do: a, else: Enum.at(list, a)
        b_val = if rem(div(parameter, 1000), 10) == 1, do: b, else: Enum.at(list, b)

        case action do
          5 ->
            if a_val != 0 do
              new_perform_actions(list, b_val)
            else
              new_perform_actions(list, pos + 3)
            end

          6 ->
            if a_val == 0 do
              new_perform_actions(list, b_val)
            else
              new_perform_actions(list, pos + 3)
            end
        end

      4 ->
        [parameter, a, b, c] = Enum.slice(list, pos, 4)
        a_val = if rem(div(parameter, 100), 10) == 1, do: a, else: Enum.at(list, a)
        b_val = if rem(div(parameter, 1000), 10) == 1, do: b, else: Enum.at(list, b)

        updated_list =
          case action do
            1 ->
              List.update_at(list, c, fn _ -> a_val + b_val end)

            2 ->
              List.update_at(list, c, fn _ -> a_val * b_val end)

            7 ->
              if a_val < b_val do
                List.update_at(list, c, fn _ -> 1 end)
              else
                List.update_at(list, c, fn _ -> 0 end)
              end

            8 ->
              if a_val == b_val do
                List.update_at(list, c, fn _ -> 1 end)
              else
                List.update_at(list, c, fn _ -> 0 end)
              end
          end

        new_perform_actions(updated_list, pos + 4)
    end
  end

  @spec part2(binary) :: binary
  def part2(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    list
    |> new_perform_actions(0)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end
end
