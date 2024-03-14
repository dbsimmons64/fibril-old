defmodule FilamentWeb.FilamentHelpers do
  use Phoenix.Component

  def html_input(assigns, %{type: :id} = field) do
    ~H"""
    <p>Id: <%= field.name %></p>
    """
  end

  def html_input(assigns, %{type: :string} = field) do
    ~H"""
    <p>String: <%= field.name %></p>
    """
  end

  def html_input(assigns, _) do
  end
end
