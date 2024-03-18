defmodule Fibril.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :date_of_birth, :date
      add :type, :string

      add :owner_id, references(:owners)

      timestamps(type: :utc_datetime)
    end
  end
end
