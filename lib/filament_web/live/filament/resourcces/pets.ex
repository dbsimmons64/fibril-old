defmodule FilamentWeb.Filament.Resourcces.Pets do
  def welcome() do
    "Hello from Pets"
  end

  def options() do
    %{
      module: Filament.Pets.Pet,
      fields: [
        :name,
        %{
          name: :type,
          label: "Genus of Animal",
          html_type: :select,
          options: %{
            "dog" => "Dog",
            "cat" => "Cat",
            "rabbit" => "Rabbit"
          }
        },
        :date_of_birth,
        %{
          name: :owner_id,
          value: :name
        }
      ],
      changeset: :name_changeset
    }
  end
end
