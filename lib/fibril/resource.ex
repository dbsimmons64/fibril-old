defmodule Fibril.Resource do
  alias Fibril.Repo
  alias Fibril.Schema
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

  def get_changeset(configuration, params) do
    resource = apply(configuration, :resource, [])
    table = apply(configuration, :table, [])

    Schema.get_changeset(
      resource.module,
      table[:changeset],
      Schema.get_struct(resource.module),
      params
    )
  end

  def get_changeset(configuration, record, params) do
    resource = apply(configuration, :resource, [])
    table = apply(configuration, :table, [])

    Schema.get_changeset(
      resource.module,
      table[:changeset],
      record,
      params
    )
  end
end
