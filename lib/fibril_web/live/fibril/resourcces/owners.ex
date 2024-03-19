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

  def table() do
    %{
      module: Fibril.Owners.Owner,
      resource: "owner",
      resources: "owners",
      fields: [:name, :id]
    }
  end
end
