defmodule FibrilWeb.FibrilLive do
  use FibrilWeb, :live_view

  alias Fibril.Repo
  alias Fibril.Schema

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(%{"resource" => resource}, _session, socket) do
    module = Module.concat(["FibrilWeb.Fibril.Resourcces", resource])
    opts = apply(module, :options, [])

    struct = Schema.get_struct(opts.module)
    fields = Schema.get_metadata_for_fields(opts.fields, opts.module) |> dbg
    changeset = Schema.get_changeset(opts.module, opts[:changeset], struct, %{})

    {:ok,
     socket
     |> assign(:title, "Welcome to Pets Admin")
     |> assign(:fields, fields)
     |> assign(:form, to_form(changeset, as: "fibril"))
     |> assign(:struct, struct)
     |> assign(:opts, opts)}
  end

  @impl true
  def handle_event("validate", %{"fibril" => fibril_params}, socket) do
    changeset =
      Schema.get_changeset(
        socket.assigns.opts.module,
        socket.assigns.opts[:changeset],
        socket.assigns.struct,
        fibril_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: "fibril"))}
  end

  def handle_event("save", %{"fibril" => fibril_params}, socket) do
    # save_resource(socket, socket.assigns.action, fibril_params)
    save_resource(socket, :new, fibril_params)
  end

  defp save_resource(socket, :new, fibril_params) do
    case create_resource(socket, fibril_params) do
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
