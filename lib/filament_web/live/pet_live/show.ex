defmodule FilamentWeb.PetLive.Show do
  use FilamentWeb, :live_view

  alias Filament.Pets

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:pet, Pets.get_pet!(id))}
  end

  defp page_title(:show), do: "Show Pet"
  defp page_title(:edit), do: "Edit Pet"
end
