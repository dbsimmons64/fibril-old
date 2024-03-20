defmodule FibrilWeb.FibrilLive.FormComponent do
  use FibrilWeb, :live_component

  alias Fibril.Schema
  alias Fibril.Resource

  alias Fibril.Repo

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage pet records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="fibril-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <%= for field <- @fields do %>
          <.fibril_input
            field={@form[field.name]}
            type={field.html_type}
            fibril={field}
            label={set_label(field)}
          />
        <% end %>
        <:actions>
          <.button phx-disable-with="Saving...">Save Pet</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{record: record} = assigns, socket) do
    resource = apply(assigns.configuration, :resource, [])
    table = apply(assigns.configuration, :table, [])

    fields = Schema.get_metadata_for_fields(table.fields, resource.module)
    changeset = Schema.get_changeset(resource.module, table[:changeset], record, %{})

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:fields, fields)
     |> assign(:form, to_form(changeset, as: "fibril"))
     |> assign(:opts, table)}
  end

  @impl true
  def handle_event("validate", %{"fibril" => fibril_params}, socket) do
    # resource = apply(socket.assigns.configuration, :resource, [])
    # table = apply(socket.assigns.configuration, :table, [])

    # changeset =
    #   Schema.get_changeset(
    #     resource.module,
    #     table[:changeset],
    #     Schema.get_struct(resource.module),
    #     fibril_params
    #   )

    changeset =
      Resource.get_changeset(socket.assigns.configuration, fibril_params)
      |> Map.put(:action, :validate)
      |> dbg()

    {:noreply, assign(socket, :form, to_form(changeset, as: "fibril"))}
  end

  def handle_event("save", %{"fibril" => fibril_params}, socket) do
    save_resource(socket, socket.assigns.action, fibril_params)
    # save_resource(socket, :new, fibril_params)
  end

  defp save_resource(socket, :edit, fibril_params) do
    case update_resource(socket, fibril_params) do
      {:ok, resource} ->
        notify_parent({:saved, resource})

        {:noreply,
         socket
         |> put_flash(:info, "Pet updated successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp save_resource(socket, :new, fibril_params) do
    case create_resource(socket, fibril_params) do
      {:ok, resource} ->
        notify_parent({:saved, resource})

        {:noreply,
         socket
         |> put_flash(:info, "Pet created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        dbg(changeset)
        {:noreply, assign_form(socket, changeset)}
    end
  end

  def create_resource(socket, attrs \\ %{}) do
    table = apply(socket.assigns.configuration, :table, [])

    Resource.get_changeset(socket.assigns.configuration, attrs)
    |> Repo.insert()
    |> Fibril.Helpers.preload(table[:preloads])
  end

  def update_resource(socket, attrs \\ %{}) do
    Resource.get_changeset(
      socket.assigns.configuration,
      socket.assigns.record,
      attrs
    )
    |> Repo.update()
    |> Fibril.Helpers.preload(socket.assigns.opts.preloads)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset, as: "fibril"))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
