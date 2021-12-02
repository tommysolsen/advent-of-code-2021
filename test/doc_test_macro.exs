defmodule DocTestAdder do
  defmacro add(x) do
    quote do
      import unquote(x)
      doctest unquote(x)
    end
  end
end
