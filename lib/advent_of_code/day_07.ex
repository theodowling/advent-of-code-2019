defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Utils.Input

  @spec part1(binary) :: integer()
  def part1(integers) do
    elements = 0..4

    combinations =
      for x <- elements,
          y <- elements,
          z <- elements,
          w <- elements,
          v <- elements,
          x != y and y != z and z != w and w != v and v != x and y != w and z != v and y != v and
            x != z and x != w,
          do: [x, y, z, w, v]

    max = Enum.max_by(combinations, fn comb -> amplification(integers, comb) end)
    amplification(integers, max)
  end

  @doc """

      iex> AdventOfCode.Day07.amplification("3,15,3,16,1002,16,10,16,1,16,15,15,4,15,99,0,0", [4,3,2,1,0])
      43210

      iex> AdventOfCode.Day07.amplification("3,23,3,24,1002,24,10,24,1002,23,-1,23,101,5,23,23,1,24,23,23,4,23,99,0,0", [0,1,2,3,4])
      54321

      iex> AdventOfCode.Day07.amplification("3,31,3,32,1002,32,10,32,1001,31,-2,31,1007,31,0,33,1002,33,7,33,1,33,31,31,1,32,31,31,4,31,99,0,0,0", [1,0,4,3,2])
      65210
  """

  @spec amplification(binary, [integer()]) :: integer()
  def amplification(program, phase_sequence) do
    list =
      program
      |> Input.comma_separated_integers()

    sequence =
      phase_sequence
      |> Enum.zip([0, nil, nil, nil, nil])

    list
    |> perform_actions(0, {sequence, 0})
  end

  @spec perform_actions(list(), integer(), {list(), integer()}) :: integer()
  def perform_actions(list, pos, _input) when pos > length(list), do: list

  def perform_actions(list, pos, input) do
    perform_action(Enum.at(list, pos), list, pos, input)
  end

  @spec perform_action(integer(), list(), integer(), {list(), integer()}) :: integer()
  def perform_action(_, list, _pos, {_, round}) when round > 5, do: list
  def perform_action(99, list, _pos, input), do: perform_action(Enum.at(list, 0), list, 0, input)

  def perform_action(parameter, list, pos, {sequence, round} = input) do
    {action, check_immediate} =
      if parameter > 99 do
        {rem(parameter, 100), true}
      else
        {parameter, false}
      end

    # IO.inspect({parameter, check_immediate, list, pos})
    n =
      cond do
        action in [3, 4] -> 2
        action in [5, 6] -> 3
        true -> 4
      end

    case n do
      2 ->
        [_parameter, a] = Enum.slice(list, pos, 2)

        case action do
          3 ->
            {var_a, var_b} = Enum.at(sequence, round)

            if var_a != nil do
              # IO.inspect("Updating with: #{var_a}")
              updated_list = List.update_at(list, a, fn _ -> var_a end)
              updated_sequence = List.update_at(sequence, round, fn _ -> {nil, var_b} end)
              perform_actions(updated_list, pos + 2, {updated_sequence, round})
            else
              # IO.inspect("Updating with: #{var_b}")
              updated_list = List.update_at(list, a, fn _ -> var_b end)
              updated_sequence = List.update_at(sequence, round, fn _ -> {nil, nil} end)
              perform_actions(updated_list, pos + 2, {updated_sequence, round})
            end

          4 ->
            # IO.inspect("Outputting value: #{Enum.at(list, a)}")

            if round == 4 do
              Enum.at(list, a)
            else
              {var_a, _} = Enum.at(sequence, round + 1)

              updated_sequence =
                List.update_at(sequence, round + 1, fn _ -> {var_a, Enum.at(list, a)} end)

              perform_actions(list, pos + 2, {updated_sequence, round + 1})
            end
        end

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
  def part2(integers, phase_sequence \\ 0) do
    list =
      integers
      |> Input.comma_separated_integers()

    sequence =
      phase_sequence
      |> Input.comma_separated_integers()
      |> Enum.zip([0, nil, nil, nil, nil])

    list
    |> perform_actions(0, {sequence, 0})
    |> Enum.map(&Integer.to_string(&1))
    |> Enum.join(",")
  end
end
