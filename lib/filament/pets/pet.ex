defmodule Filament.Pets.Pet do
  use Ecto.Schema

  import Ecto.Changeset

  schema "pets" do
    field :name, :string
    field :date_of_birth, :date
    field :type, :string

    belongs_to :owner, Filament.Owners.Owner
    has_many :treatments, Filament.Treatments.Treatment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth, :type, :owner_id])
    |> validate_required([:name, :date_of_birth, :type, :owner_id])
  end

  def name_changeset(pet, attrs) do
    pet
    |> cast(attrs, [:name, :date_of_birth, :type, :owner_id])
    |> validate_required([:name, :date_of_birth, :type, :owner_id])
    |> validate_length(:name, max: 5)
  end
end
