defmodule Fibril.Fibril do
  alias Fibril.Repo
  require Ecto.Query

  def list_records(struct, _preloads = nil) do
    struct
    |> Repo.all()
  end

  def list_records(struct, preloads) do
    struct
    |> Ecto.Query.preload(^preloads)
    |> Repo.all()
  end
end
