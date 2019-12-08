defmodule AdventOfCode.Day05 do
  alias AdventOfCode.Utils.Input

  @spec part1(binary) :: binary
  def part1(integers, input \\ 1) do
    list =
      integers
      |> Input.comma_separated_integers()

    list
    |> perform_actions(0, input)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end

  @spec perform_actions(list(), integer(), integer()) :: any
  def perform_actions(list, pos, _input) when pos > length(list), do: list

  def perform_actions(list, pos, input) do
    perform_action(Enum.at(list, pos), list, pos, input)
  end

  @spec perform_action(integer(), list(), integer(), integer()) :: list()
  def perform_action(99, list, _pos, _), do: list

  def perform_action(parameter, list, pos, input) do
    {action, check_immediate} =
      if parameter > 99 do
        {rem(parameter, 100), true}
      else
        {parameter, false}
      end

    IO.inspect({parameter, check_immediate, list, pos})

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
              IO.inspect("Updating with: #{input}")
              List.update_at(list, a, fn _ -> input end)

            4 ->
              IO.inspect("Outputting value: #{Enum.at(list, a)}")
              list
          end

        perform_actions(updated_list, pos + 2, input)

      3 ->
        [parameter, a, b] = Enum.slice(list, pos, 3)

        a_val =
          if check_immediate and rem(div(parameter, 100), 10) == 1, do: a, else: Enum.at(list, a)

        b_val =
          if check_immediate and rem(div(parameter, 1000), 10) == 1, do: b, else: Enum.at(list, b)

        case action do
          5 ->
            if a_val != 0 do
              perform_actions(list, b_val, input)
            else
              perform_actions(list, pos + 3, input)
            end

          6 ->
            if a_val == 0 do
              perform_actions(list, b_val, input)
            else
              perform_actions(list, pos + 3, input)
            end
        end

      4 ->
        [parameter, a, b, c] = Enum.slice(list, pos, 4)

        a_val =
          if check_immediate and rem(div(parameter, 100), 10) == 1, do: a, else: Enum.at(list, a)

        b_val =
          if check_immediate and rem(div(parameter, 1000), 10) == 1, do: b, else: Enum.at(list, b)

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

        perform_actions(updated_list, pos + 4, input)
    end
  end

  @spec part2(binary) :: binary
  def part2(integers) do
    list =
      integers
      |> Input.comma_separated_integers()

    list
    |> perform_actions(0, 5)
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end
end
