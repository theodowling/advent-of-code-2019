defmodule AdventOfCode.Day14 do
  @ore 1_000_000_000_000
  def part1(input, need_count \\ 1) do
    combinations = parse(input)

    {ing, _ext} =
      combinations
      |> calculate_ingredients("FUEL", need_count)
      |> get_ingredients(combinations)

    Map.get(ing, "ORE")
  end

  def parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.reduce(%{}, fn line, acc ->
      [i, o] = String.split(line, " => ")
      [ov, ok] = String.split(o, " ")

      inputs =
        String.split(i, ", ")
        |> Enum.map(fn item ->
          [iv, ik] = String.split(item, " ")
          {ik, String.to_integer(iv)}
        end)

      Map.put(
        acc,
        ok,
        {String.to_integer(ov), inputs}
      )
    end)
  end

  def calculate_ingredients(combinations, output, need_count) do
    {1, ingredients} = Map.get(combinations, output)

    ingredients
    |> Enum.map(fn {k, v} -> {k, v * need_count} end)
    |> Enum.into(%{})

    # |> IO.inspect(label: "Ingredients")
  end

  def get_ingredients(ingredients, combinations, extra \\ %{})

  def get_ingredients(ingredients, _, extra) when map_size(ingredients) == 1,
    do: {ingredients, extra}

  def get_ingredients(required_elements, recipies, extra) do
    {updated_required_elements, updated_extra} =
      required_elements
      |> Enum.reduce({%{}, extra}, fn {req_element, req_element_count}, {acc, extra} ->
        if req_element == "ORE" do
          {Map.update(acc, req_element, req_element_count, &(&1 + req_element_count)), extra}
        else
          already_have = Map.get(extra, req_element, 0)

          {req_element_count, remaining} =
            if already_have > 0 do
              actually_required = max(req_element_count - already_have, 0)
              remaining = max(already_have - req_element_count, 0)
              {actually_required, remaining}
            else
              {req_element_count, 0}
            end

          # |> IO.inspect(label: "#{req_element}")

          extra = Map.put(extra, req_element, remaining)

          {acc, overproduction} =
            if req_element_count > 0 do
              {recipe_count, ingredients} = Map.get(recipies, req_element)

              {repeat_recipe_count, extra_of_req_element} =
                if req_element_count > recipe_count do
                  count =
                    if rem(req_element_count, recipe_count) > 0,
                      do: div(req_element_count, recipe_count) + 1,
                      else: div(req_element_count, recipe_count)

                  {count, recipe_count * count - req_element_count}
                else
                  {1, recipe_count - req_element_count}
                end

              acc =
                Enum.reduce(ingredients, acc, fn {k, v}, acc ->
                  Map.update(acc, k, v * repeat_recipe_count, &(v * repeat_recipe_count + &1))
                end)

              # IO.inspect("produced #{repeat_recipe_count} units of #{req_element}")
              {acc, extra_of_req_element}
            else
              {acc, 0}
            end

          extra = Map.update(extra, req_element, overproduction, &(&1 + overproduction))
          # |> IO.inspect()

          {acc, extra}
        end
      end)

    get_ingredients(updated_required_elements, recipies, updated_extra)
  end

  # 10 ORE => 10 A
  # 1 ORE => 1 B
  # 7 A, 1 B => 1 C
  # 7 A, 1 C => 1 D
  # 7 A, 1 D => 1 E
  # 7 A, 1 E => 1 FUEL

  def produce_fuel(ingredients, recipes, %{"ORE" => available_ore} = extra, n)
      when available_ore > 0 do
    {%{"ORE" => ore}, ext} = get_ingredients(ingredients, recipes, extra)
    ext = Map.update(ext, "ORE", 0, &(&1 - ore))
    # IO.inspect({ext, ore})
    produce_fuel(ingredients, recipes, ext, n + 1)
  end

  # def part2(input) do
  #   available_ore = 1_000_000_000_000
  #   combinations = parse(input)

  #   combinations
  #   |> calculate_ingredients("FUEL")
  #   |> produce_fuel(combinations, %{"ORE" => available_ore}, 0)
  # end

  # This could be more efficient, it will never be 1-1, doesn't affect run-time
  def part2(input), do: part2(input, {0, @ore})

  def part2(input, {min, max}) when min + 1 == max do
    test = part1(input, max)

    if test > @ore do
      min
    else
      max
    end
  end

  def part2(input, {min, max}) do
    middle = ceil((max - min) / 2) + min
    answer = part1(input, middle)

    next_range =
      cond do
        answer < @ore -> {middle, max}
        answer > @ore -> {min, middle}
      end

    part2(input, next_range)
  end
end
