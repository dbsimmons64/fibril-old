defmodule FibrilWeb.Fibril.Resourcces.Owners do
  def resource do
    %{module: Fibril.Owners.Owner, name: "owner", plural: "owners"}
  end

  def form() do
    %{
      fields: [:name]
    }
  end

  def table() do
    %{
      fields: [:name]
    }
  end
end
