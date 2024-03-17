defmodule Filament.Pets.Pet do
  use Ecto.Schema

  import Ecto.Changeset

  schema "pets" do
    field :name, :string
    field :date_of_birth, :date
    field :type, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth, :type])
    |> validate_required([:name, :date_of_birth, :type])
  end

  def name_changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth, :type])
    |> validate_required([:name, :date_of_birth, :type])
    |> validate_length(:name, max: 5)
  end
end
