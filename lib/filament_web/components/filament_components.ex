defmodule FilamentWeb.FilamentComponents do
  use Phoenix.Component
  import FilamentWeb.CoreComponents

  def filament_input(%{type: :text} = assigns) do
    ~H"""
    <.input field={@field} type="text" label={@label} />
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
    dbg(field)
    field[:label] || create_label(field.name)
  end

  def create_label(name) do
    dbg(name)

    name
    |> Atom.to_string()
    |> String.capitalize()
    |> String.replace("_", " ")
  end
end
