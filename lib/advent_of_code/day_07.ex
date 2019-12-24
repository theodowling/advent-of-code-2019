defmodule AdventOfCode.Day07 do
  alias AdventOfCode.Utils.Input
  import AdventOfCode.Utils.Intcode

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

    main_pid = inspect(self())

    processes =
      for i <- 1..5 do
        Task.async(fn ->
          Process.register(self(), :"#{main_pid}_node_#{i}")

          run(list, %{
            blocking: true,
            inputs: [0],
            next_process: if(i == 5, do: nil, else: :"#{main_pid}_node_#{rem(i, 5) + 1}")
          })
        end)
      end

    for i <- 0..4 do
      send(Enum.at(processes, i).pid, {:input, Enum.at(phase_sequence, i)})
    end

    send(Enum.at(processes, 0).pid, {:input, 0})

    for proc <- processes do
      Task.await(proc)
    end
    |> Enum.at(-1)
  end

  @doc """

      iex> AdventOfCode.Day07.amplification_with_loopback("3,26,1001,26,-4,26,3,27,1002,27,2,27,1,27,26,27,4,27,1001,28,-1,28,1005,28,6,99,0,0,5", [9,8,7,6,5])
      139629729

      iex> AdventOfCode.Day07.amplification_with_loopback("3,52,1001,52,-5,52,3,53,1,52,56,54,1007,54,5,55,1005,55,26,1001,54,-5,54,1105,1,12,1,53,54,53,1008,54,0,55,1001,55,1,55,2,53,55,53,4,53,1001,56,-1,56,1005,56,6,99,0,0,0,0,10", [9,7,8,5,6])
      18216
  """

  def amplification_with_loopback(program, phase_sequence) do
    list =
      program
      |> Input.comma_separated_integers()

    main_pid = inspect(self())

    processes =
      for i <- 1..5 do
        Task.async(fn ->
          Process.register(self(), :"#{main_pid}_node_#{i}")

          run(list, %{
            blocking: true,
            inputs: [0],
            next_process: :"#{main_pid}_node_#{rem(i, 5) + 1}"
          })
        end)
      end

    for i <- 0..4 do
      send(Enum.at(processes, i).pid, {:input, Enum.at(phase_sequence, i)})
    end

    send(Enum.at(processes, 0).pid, {:input, 0})

    for proc <- processes do
      Task.await(proc)
    end
    # |> IO.inspect()
    |> Enum.at(-1)
  end

  @spec part2(binary, any) :: [any]
  def part2(integers, _phase_sequence \\ 0) do
    elements = 5..9

    combinations =
      for x <- elements,
          y <- elements,
          z <- elements,
          w <- elements,
          v <- elements,
          x != y and y != z and z != w and w != v and v != x and y != w and z != v and y != v and
            x != z and x != w,
          do: [x, y, z, w, v]

    max = Enum.max_by(combinations, fn comb -> amplification_with_loopback(integers, comb) end)
    amplification_with_loopback(integers, max)
  end
end
