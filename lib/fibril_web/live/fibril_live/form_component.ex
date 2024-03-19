defmodule FibrilWeb.FibrilLive.FormComponent do
  use FibrilWeb, :live_component

  alias Fibril.Schema

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
          <%!-- <.input field={@form[field.name]} type={field.html_type} label="Something" /> --%>
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
    IO.puts("Update called!!!!!!!!!!!!!!!!!!!")

    module =
      Module.concat(["FibrilWeb.Fibril.Resourcces", String.capitalize(assigns.resources)])

    opts = apply(module, :options, []) |> dbg()

    struct = Schema.get_struct(opts.module)
    fields = Schema.get_metadata_for_fields(opts.fields, opts.module)
    changeset = Schema.get_changeset(opts.module, opts[:changeset], record, %{})

    {:ok,
     socket
     |> assign(assigns)
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
        notify_parent({:saved, resource})

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
    |> Fibril.Helpers.preload(socket.assigns.opts.preloads)
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
