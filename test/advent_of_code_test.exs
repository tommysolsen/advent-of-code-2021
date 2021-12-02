defmodule DocTestAdder do
  defmacro add(x) do
    quote do
      doctest unquote(x)
    end
  end
end

defmodule AdventOfCodeTest do
  require DocTestAdder
  import Enum
  use ExUnit.Case
  doctest AdventOfCode

  elem(File.ls("./lib"), 1)
  |> filter(&String.starts_with?(&1, "day"))
  |> map(&String.to_atom("Elixir.AdventOfCode." <> Macro.camelize(String.replace(&1, ".ex", ""))))
  |> map(&DocTestAdder.add/1)
end
