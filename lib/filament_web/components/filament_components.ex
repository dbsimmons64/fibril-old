defmodule FilamentWeb.FilamentComponents do
  require Ecto.Query
  use Phoenix.Component
  import FilamentWeb.CoreComponents
  alias Filament.Repo

  def filament_input(%{type: :text} = assigns) do
    ~H"""
    <.input field={@field} type="text" label={@label} />
    """
  end

  def filament_input(%{type: :association} = assigns) do
    # struct = apply(assigns.filament.association, :__struct__, [])
    name = assigns.filament.value

    options =
      assigns.filament.association.queryable
      |> Ecto.Query.select([a], {field(a, ^name), a.id})
      |> Repo.all()

    ~H"""
    <.input field={@field} type="select" options={options} label={@label} />
    """
  end

  def filament_input(%{type: :date} = assigns) do
    ~H"""
    <.input field={@field} type="date" label={@label} />
    """
  end

  def filament_input(%{type: :select} = assigns) do
    ~H"""
    <.input field={@field} type="select" options={assigns.filament.options} label={@label} />
    """
  end

  def set_label(field) do
    field[:label] || create_label(field.name)
  end

  def create_label(name) do
    name
    |> Atom.to_string()
    |> String.capitalize()
    |> String.replace("_", " ")
  end
end
