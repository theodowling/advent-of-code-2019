defmodule AdventOfCode.Utils.Intcode do
  defmodule State do
    defstruct inputs: nil,
              outputs: nil,
              repeat: false,
              blocking: true,
              next_process: nil,
              relative_base: 0
  end

  def run(program, state) do
    updated_program =
      program
      |> Enum.with_index()
      |> Enum.map(fn {v, k} -> {k, v} end)
      |> Enum.into(%{})

    if Map.has_key?(state, :relative_base),
      do: run(updated_program, 0, state),
      else: run(updated_program, 0, Map.put(state, :relative_base, 0))
  end

  def run(program, pos, state) do
    execute_action(determine_action_and_values(program[pos]), program, pos, state)
  end

  # Might need to repeat
  def execute_action([99 | _], program, _, %{repeat: true} = state) do
    execute_action(program[0], program, 0, state)
  end

  # Otherwise it will just terminate
  def execute_action([99 | _], program, _, _), do: program |> Enum.map(fn {_, v} -> v end)

  def execute_action([1, a, b, c], program, pos, state) do
    {a, b, c} =
      {deref(a, program, pos + 1, state), deref(b, program, pos + 2, state),
       deref(c, program, pos + 3, state, :pointer)}

    run(Map.put(program, c, a + b), pos + 4, state)
  end

  def execute_action([2, a, b, c], program, pos, state) do
    {a, b, c} =
      {deref(a, program, pos + 1, state), deref(b, program, pos + 2, state),
       deref(c, program, pos + 3, state, :pointer)}

    run(Map.put(program, c, a * b), pos + 4, state)
  end

  def execute_action([3, a | _], program, pos, %{blocking: true} = state) do
    input =
      receive do
        {:input, input} -> input
      after
        10_000 -> :timeout
      end

    a = deref(a, program, pos + 1, state, :pointer)
    IO.inspect("Received #{input} as a message")
    run(Map.put(program, a, input), pos + 2, state)
  end

  def execute_action([3, a | _], program, pos, %{inputs: inputs} = state) do
    [input | rest] = inputs
    a = deref(a, program, pos + 1, state, :pointer)
    updated_state = Map.put(state, :inputs, rest)
    run(Map.put(program, a, input), pos + 2, updated_state)
  end

  def execute_action(
        [4, a | _],
        program,
        pos,
        %{blocking: true, next_process: next_process} = state
      ) do
    a = deref(a, program, pos + 1, state)

    if next_process == nil do
      a
    else
      if next_process |> Process.whereis() do
        send(next_process, {:input, a})
        run(program, pos + 2, state)
      else
        a
      end
    end
  end

  def execute_action([4, a | _], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    IO.inspect("Value is #{a}")
    run(program, pos + 2, state)
  end

  def execute_action([5, a, b | _], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    b = deref(b, program, pos + 2, state)

    if a != 0 do
      run(program, b, state)
    else
      run(program, pos + 3, state)
    end
  end

  def execute_action([6, a, b | _], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    b = deref(b, program, pos + 2, state)

    if a == 0 do
      run(program, b, state)
    else
      run(program, pos + 3, state)
    end
  end

  def execute_action([7, a, b, c], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    b = deref(b, program, pos + 2, state)
    c = deref(c, program, pos + 3, state, :pointer)

    if a < b do
      run(Map.put(program, c, 1), pos + 4, state)
    else
      run(Map.put(program, c, 0), pos + 4, state)
    end
  end

  def execute_action([8, a, b, c], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    b = deref(b, program, pos + 2, state)
    c = deref(c, program, pos + 3, state, :pointer)

    if a == b do
      run(Map.put(program, c, 1), pos + 4, state)
    else
      run(Map.put(program, c, 0), pos + 4, state)
    end
  end

  def execute_action([9, a | _], program, pos, state) do
    a = deref(a, program, pos + 1, state)
    updated_state = Map.update(state, :relative_base, 0, &(&1 + a))
    run(program, pos + 2, updated_state)
  end

  defp deref(mode, program, pos, base, type \\ :value),
    do: do_deref(mode, program, pos, base, type) || 0

  defp do_deref(0, program, pos, _base, :value), do: program[program[pos]]
  defp do_deref(1, program, pos, _base, _), do: program[pos]
  defp do_deref(2, program, pos, %{relative_base: base}, :value), do: program[base + program[pos]]
  defp do_deref(0, program, pos, _base, :pointer), do: program[pos]
  defp do_deref(2, program, pos, %{relative_base: base}, :pointer), do: base + program[pos]

  defp determine_action_and_values(ins) do
    {ins, op} = {div(ins, 100), Integer.mod(ins, 100)}
    {ins, c} = {div(ins, 10), Integer.mod(ins, 10)}
    {ins, b} = {div(ins, 10), Integer.mod(ins, 10)}
    a = Integer.mod(ins, 10)
    [op, c, b, a]
  end
end
