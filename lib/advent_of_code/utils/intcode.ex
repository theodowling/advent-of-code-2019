defmodule AdventOfCode.Utils.Intcode do
  defmodule State do
    defstruct inputs: nil, outputs: nil, repeat: false, blocking: true, next_process: nil
  end

  @spec run([integer()], any) :: [integer()]
  def run(program, state) do
    run(program, 0, state)
  end

  @spec run([integer()], integer(), map()) :: [integer()]
  def run(program, pos, _state) when pos > length(program), do: program

  def run(program, pos, state) do
    execute_action(Enum.at(program, pos), program, pos, state)
  end

  @spec execute_action(integer(), [integer()], integer(), map(), boolean) :: any
  def execute_action(code, program, pos, state, check_immediate \\ false)

  # Might need to repeat
  def execute_action(99, program, _, %{repeat: true} = state, _) do
    execute_action(Enum.at(program, 0), program, 0, state)
  end

  # Otherwise it will just terminate
  def execute_action(99, program, _, _, _), do: program

  def execute_action(action, program, pos, state, _) when action > 99 do
    # IO.inspect("at action: #{action} on pos #{pos}")

    action
    |> determine_action_and_values(program, pos, true)
    |> execute_action_with_values(program, pos, state)
  end

  def execute_action(action, program, pos, state, _) do
    # IO.inspect("at action: #{action} on pos #{pos}")

    action
    |> determine_action_and_values(program, pos, false)
    |> execute_action_with_values(program, pos, state)
  end

  def execute_action_with_values({1, a, b, c}, program, pos, state) do
    updated_program = List.update_at(program, c, fn _ -> a + b end)
    execute_action(Enum.at(updated_program, pos + 4), updated_program, pos + 4, state)
  end

  def execute_action_with_values({2, a, b, c}, program, pos, state) do
    updated_program = List.update_at(program, c, fn _ -> a * b end)
    execute_action(Enum.at(updated_program, pos + 4), updated_program, pos + 4, state)
  end

  def execute_action_with_values({3, a, _, _}, program, pos, %{blocking: true} = state) do
    input =
      receive do
        {:input, input} -> input
      after
        10_000 -> :timeout
      end

    IO.inspect("Received #{input} as a message")
    updated_program = List.update_at(program, a, fn _ -> input end)
    execute_action(Enum.at(updated_program, pos + 2), updated_program, pos + 2, state)
  end

  def execute_action_with_values({3, a, _, _}, program, pos, %{inputs: inputs} = state) do
    [input | rest] = inputs
    updated_state = Map.put(state, :inputs, rest)
    updated_program = List.update_at(program, a, fn _ -> input end)
    execute_action(Enum.at(updated_program, pos + 2), updated_program, pos + 2, updated_state)
  end

  def execute_action_with_values(
        {4, a, _, _},
        program,
        pos,
        %{inputs: _inputs, blocking: true, next_process: next_process} = state
      ) do
    if next_process == nil do
      Enum.at(program, a)
    else
      # IO.inspect("Sending #{Enum.at(program, a)} to next_process #{next_process}")

      if next_process |> Process.whereis() do
        send(next_process, {:input, Enum.at(program, a)})
        execute_action(Enum.at(program, pos + 2), program, pos + 2, state)
      else
        Enum.at(program, a)
      end
    end
  end

  def execute_action_with_values({4, a, _, _}, program, pos, state) do
    IO.inspect("Value at #{a} is #{Enum.at(program, a)}")
    execute_action(Enum.at(program, pos + 2), program, pos + 2, state)
  end

  def execute_action_with_values({5, a, b, _}, program, pos, state) do
    if a != 0 do
      execute_action(Enum.at(program, b), program, b, state)
    else
      execute_action(Enum.at(program, pos + 3), program, pos + 3, state)
    end
  end

  def execute_action_with_values({6, a, b, _}, program, pos, state) do
    if a == 0 do
      execute_action(Enum.at(program, b), program, b, state)
    else
      execute_action(Enum.at(program, pos + 3), program, pos + 3, state)
    end
  end

  def execute_action_with_values({7, a, b, c}, program, pos, state) do
    updated_program =
      if a < b do
        List.update_at(program, c, fn _ -> 1 end)
      else
        List.update_at(program, c, fn _ -> 0 end)
      end

    execute_action(Enum.at(updated_program, pos + 4), updated_program, pos + 4, state)
  end

  def execute_action_with_values({8, a, b, c}, program, pos, state) do
    updated_program =
      if a == b do
        List.update_at(program, c, fn _ -> 1 end)
      else
        List.update_at(program, c, fn _ -> 0 end)
      end

    execute_action(Enum.at(updated_program, pos + 4), updated_program, pos + 4, state)
  end

  defp determine_action_and_values(_action, program, pos, check_immediate) do
    sliced = Enum.slice(program, pos, 4)

    [action_integer, a, b, c] =
      case length(sliced) do
        4 ->
          [action_integer, a, b, c] = sliced
          [action_integer, a, b, c]

        3 ->
          [action_integer, a, b] = sliced
          [action_integer, a, b, nil]

        2 ->
          [action_integer, a] = sliced
          [action_integer, a, nil, nil]
      end

    action = rem(action_integer, 100)

    # actions 3 and 4 are always immediate positions
    [a_val, b_val] =
      if action in [3, 4] do
        [a, b]
      else
        a_val =
          if check_immediate and rem(div(action_integer, 100), 10) == 1,
            do: a,
            else: Enum.at(program, a)

        b_val =
          if check_immediate and rem(div(action_integer, 1000), 10) == 1,
            do: b,
            else: Enum.at(program, b)

        [a_val, b_val]
      end

    {action, a_val, b_val, c}
  end
end
