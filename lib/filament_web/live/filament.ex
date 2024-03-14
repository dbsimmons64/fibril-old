defmodule FilamentWeb.FilamentLive do
  alias FilamentWeb.PetLive.FormComponent
  use FilamentWeb, :live_view

  alias FilamentWeb.FilamentHelpers
  alias Filament.Schema

  @impl true
  def mount(_params, _session, socket) do
    opts = %{
      schema: Filament.Pets.Pet,
      changeset: &Filament.Pets.Pet.changeset/2,
      fields: [:name, :date_of_birth]
    }

    fields = Schema.get_metadata_for_fields(opts.fields, opts.schema) |> dbg()

    struct = apply(opts.schema, :__struct__, [])
    # apply(opts.schema, :changeset, [struct, %{}]) |> dbg()

    changeset = opts.changeset.(struct, %{})
    socket = assign(socket, :form, to_form(changeset))

    # fields = apply(Filament.Pets.Pet, :__schema__, [:fields])

    schema =
      Enum.map(fields, fn field ->
        %{name: field, type: apply(Filament.Pets.Pet, :__schema__, [:type, field])}
      end)

    html =
      Enum.map(schema, fn field ->
        FilamentHelpers.html_input(socket.assigns, field)
      end)

    {:ok,
     socket
     |> assign(:title, "Welcome to Pets Admin")
     |> assign(:fields, fields)
     |> assign(:html, html)}
  end

  # Module.concat() #

  @impl true
end
