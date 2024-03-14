defmodule Filament.PetsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Filament.Pets` context.
  """

  @doc """
  Generate a pet.
  """
  def pet_fixture(attrs \\ %{}) do
    {:ok, pet} =
      attrs
      |> Enum.into(%{
        date_of_birth: ~D[2024-03-12],
        name: "some name"
      })
      |> Filament.Pets.create_pet()

    pet
  end
end
