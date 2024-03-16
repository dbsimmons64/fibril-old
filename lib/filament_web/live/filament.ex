defmodule FilamentWeb.FilamentLive do
  use FilamentWeb, :live_view

  alias Filament.Schema

  @impl true
  @spec mount(any(), any(), map()) :: {:ok, map()}
  def mount(%{"resource" => resource}, _session, socket) do
    module = Module.concat(["FilamentWeb.Filament.Resourcces", resource])
    opts = apply(module, :options, [])

    # mod = Module.concat(["FilamentWeb.Filament.Resourcces", "Pets"])
    # mod = Module.concat(["FilamentWeb.Filament.Resourcces", :Pets])
    # apply(mod, :welcome, []) |> dbg()

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
  def handle_event("validate", %{"filament" => pet_params} = params, socket) do
    changeset =
      Schema.get_changeset(
        socket.assigns.opts.module,
        socket.assigns.opts[:changeset],
        socket.assigns.struct,
        pet_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset, as: "filament"))}
  end
end
