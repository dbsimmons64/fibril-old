defmodule FilamentWeb.Filament.Resourcces.Pets do
  def welcome() do
    "Hello from Pets"
  end

  def options() do
    %{
      module: Filament.Pets.Pet,
      fields: [:name, :date_of_birth],
      changeset: :name_changeset
    }
  end
end
