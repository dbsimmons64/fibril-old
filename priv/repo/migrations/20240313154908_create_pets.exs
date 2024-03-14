defmodule Filament.Repo.Migrations.CreatePets do
  use Ecto.Migration

  def change do
    create table(:pets) do
      add :name, :string
      add :date_of_birth, :date

      timestamps(type: :utc_datetime)
    end
  end
end
