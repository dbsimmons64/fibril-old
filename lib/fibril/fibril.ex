defmodule Fibril.Fibril do
  alias Fibril.Repo
  require Ecto.Query

  def list_records(struct, _preloads = nil) do
    IO.puts("Just list records !!!!!!!!")

    struct
    |> Repo.all()
  end

  def list_records(struct, preloads) do
    IO.puts("List Records with Preloads!!!!!!!!!!!!!")

    struct
    |> Ecto.Query.preload(^preloads)
    |> Repo.all()
  end
end
