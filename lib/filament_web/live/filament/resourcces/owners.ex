defmodule FilamentWeb.Filament.Resourcces.Owners do
  def welcome() do
    "Hello from Owners"
  end

  def options() do
    %{
      module: Filament.Owners.Owner,
      fields: [:name]
    }
  end
end
