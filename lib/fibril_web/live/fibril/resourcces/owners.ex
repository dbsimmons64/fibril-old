defmodule FibrilWeb.Fibril.Resourcces.Owners do
  def welcome() do
    "Hello from Owners"
  end

  def options() do
    %{
      module: Fibril.Owners.Owner,
      fields: [:name]
    }
  end
end
