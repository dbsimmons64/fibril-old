defmodule FilamentWeb.FilamentComponents do
  use Phoenix.Component
  import FilamentWeb.CoreComponents

  def fc_input(assigns) do
    ~H"""
    <.input field={@form[:name]} type={@field.type} label="Name" />
    """
  end
end
