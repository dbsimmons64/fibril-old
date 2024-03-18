defmodule Fibril.Owners.Owner do
  use Ecto.Schema

  import Ecto.Changeset

  schema "owners" do
    field :name, :string

    has_many :pets, Fibril.Pets.Pet

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
