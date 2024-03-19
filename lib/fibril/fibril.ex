defmodule Fibril.Fibril do
  alias Fibril.Repo
  require Ecto.Query

  def list_resources(struct, _preloads = nil) do
    struct
    |> Repo.all()
  end

  def list_resources(struct, preloads) do
    struct
    |> Ecto.Query.preload(^preloads)
    |> Repo.all()
  end
end
