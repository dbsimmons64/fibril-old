defmodule Filament.Repo.Migrations.CreateTreatments do
  use Ecto.Migration

  def change do
    create table(:treatments) do
      add :description, :string
      add :notes, :text
      add :price, :integer

      add :pet_id, references(:pets)

      timestamps(type: :utc_datetime)
    end
  end
end
