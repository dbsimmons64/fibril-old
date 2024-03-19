defmodule FibrilWeb.Fibril.Resourcces.Pets do
  import Ecto.Query, warn: false

  def welcome() do
    "Hello from Pets"
  end

  def table() do
    %{
      module: Fibril.Pets.Pet,
      resource: "pet",
      resources: "pets",
      fields: [
        :name,
        :date_of_birth,
        :type,
        [:owner, :name]
      ],
      preloads: [
        :owner
      ]
    }
  end

  def options() do
    %{
      module: Fibril.Pets.Pet,
      resource: "pet",
      resources: "pets",
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
          queryable: &not_first/0,
          value: :name
        }
      ],
      changeset: :name_changeset,
      preloads: [:owner]
    }
  end

  def not_first() do
    from(
      a in Fibril.Owners.Owner,
      where: a.id > 1
    )
  end
end
