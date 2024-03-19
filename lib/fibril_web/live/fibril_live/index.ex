defmodule FibrilWeb.FibrilLive.Index do
  use FibrilWeb, :live_view

  alias Fibril.Pets
  alias Fibril.Pets.Pet
  alias Fibril.Schema
  alias Fibril.Fibril

  @impl true
  def mount(%{"resource" => resource}, _session, socket) do
    # {:ok, stream(socket, :pets, Pets.list_pets())}

    module = Module.concat(["FibrilWeb.Fibril.Resourcces", String.capitalize(resource)])
    table = apply(module, :table, [])

    table = Map.put(table, :name, resource)
    # struct = Schema.get_struct(table.module)
    # fields = Schema.get_metadata_for_fields(table.fields, table.module) |> dbg

    {:ok,
     socket
     |> assign(:name, table.name)
     |> assign(:fields, table.fields)
     |> assign(:module, module)
     |> stream(:resources, Fibril.list_resources(table.module, table[:preloads]))}
  end

  @impl true
  @spec handle_params(any(), any(), %{
          :assigns => atom() | %{:live_action => :edit | :index | :new, optional(any()) => any()},
          optional(any()) => any()
        }) :: {:noreply, map()}
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Pet")
    |> assign(:pet, Pets.get_pet!(id))
  end

  defp apply_action(socket, :new, _params) do
    IO.puts("NEW called!!!!!!")

    socket
    |> assign(:page_title, "New Pet")
    |> assign(:pet, %Pet{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Pets")
    |> assign(:pet, nil)
  end

  @impl true
  def handle_info({FibrilWeb.PetLive.FormComponent, {:saved, pet}}, socket) do
    {:noreply, stream_insert(socket, :pets, pet)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pet = Pets.get_pet!(id)
    {:ok, _} = Pets.delete_pet(pet)

    {:noreply, stream_delete(socket, :pets, pet)}
  end
end
