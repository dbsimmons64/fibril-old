defmodule FilamentWeb.FilamentLive do
  use FilamentWeb, :live_view

  alias Filament.Repo
  alias Filament.Schema

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(%{"resource" => resource}, _session, socket) do
    module = Module.concat(["FilamentWeb.Filament.Resourcces", resource])
    opts = apply(module, :options, [])

    struct = Schema.get_struct(opts.module)
    fields = Schema.get_metadata_for_fields(opts.fields, opts.module)
    changeset = Schema.get_changeset(opts.module, opts[:changeset], struct, %{})

    {:ok,
     socket
     |> assign(:title, "Welcome to Pets Admin")
     |> assign(:fields, fields)
     |> assign(:form, to_form(changeset, as: "filament"))
     |> assign(:struct, struct)
     |> assign(:opts, opts)}
  end

  @impl true
  def handle_event("validate", %{"filament" => filament_params}, socket) do
    changeset =
      Schema.get_changeset(
        socket.assigns.opts.module,
        socket.assigns.opts[:changeset],
        socket.assigns.struct,
        filament_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: "filament"))}
  end

  def handle_event("save", %{"filament" => filament_params}, socket) do
    # save_resource(socket, socket.assigns.action, filament_params)
    save_resource(socket, :new, filament_params)
  end

  defp save_resource(socket, :new, filament_params) do
    case create_resource(socket, filament_params) do
      {:ok, resource} ->
        #  notify_parent({:saved, pet})

        {:noreply,
         socket
         |> put_flash(:info, "Pet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def create_resource(socket, attrs \\ %{}) do
    Schema.get_changeset(
      socket.assigns.opts.module,
      socket.assigns.opts[:changeset],
      socket.assigns.struct,
      attrs
    )
    |> Repo.insert()
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end
end
