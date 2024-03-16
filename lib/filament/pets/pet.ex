defmodule Filament.Pets.Pet do
  use Ecto.Schema
  use Filament.Macros

  import Ecto.Changeset

  admin(Filament.Pets.Pet)

  schema "pets" do
    field :name, :string, default: "Rover"
    field :date_of_birth, :date

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth])
    |> validate_required([:name, :date_of_birth])
  end

  def name_changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth])
    |> validate_required([:name, :date_of_birth])
    |> validate_length(:name, max: 5)
  end
end
