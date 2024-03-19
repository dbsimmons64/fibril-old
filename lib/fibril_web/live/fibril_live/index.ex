defmodule FibrilWeb.FibrilLive.Index do
  use FibrilWeb, :live_view

  alias Fibril.Pets
  alias Fibril.Schema
  alias Fibril.Fibril

  @impl true
  def mount(%{"resource" => resource}, _session, socket) do
    module = Module.concat(["FibrilWeb.Fibril.Resourcces", String.capitalize(resource)])

    table = apply(module, :table, [])

    {:ok,
     socket
     |> assign(:resource, table.resource)
     |> assign(:resources, table.resources)
     |> assign(:fields, table.fields)
     |> assign(:module, module)
     |> stream(:records, Fibril.list_records(table.module, table[:preloads]))}
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
    table = apply(socket.assigns.module, :options, [])

    Schema.get_struct(table.module)

    socket
    |> assign(:page_title, "New Pet")
    |> assign(:record, Schema.get_struct(table.module))
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing #{socket.assigns.resources}")
    |> assign(:pet, nil)
  end

  @impl true
  def handle_info({FibrilWeb.PetLive.FormComponent, {:saved, pet}}, socket) do
    {:noreply, stream_insert(socket, :pets, pet)}
  end

  @impl true
  def handle_info({FibrilWeb.FibrilLive.FormComponent, {:saved, record}}, socket) do
    {:noreply, stream_insert(socket, :records, record)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pet = Pets.get_pet!(id)
    {:ok, _} = Pets.delete_pet(pet)

    {:noreply, stream_delete(socket, :pets, pet)}
  end

  def fetch_data(record, fields) when is_list(fields) do
    keys = Enum.map(fields, fn field -> Access.key(field, %{}) end)
    get_in(record, keys)
  end

  def fetch_data(record, field) do
    Map.get(record, field)
  end
end
