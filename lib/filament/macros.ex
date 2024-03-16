defmodule Filament.Macros do
  defmacro __using__(_opts) do
    quote do
      import Filament.Macros

      @resources []

      @before_compile Filament.Macros
    end
  end

  defmacro admin(resource) do
    quote do
      @resources [unquote(resource) | @resources]
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      Enum.each(@resources, fn name ->
        IO.puts("Found #{name}")
      end)
    end
  end
end
