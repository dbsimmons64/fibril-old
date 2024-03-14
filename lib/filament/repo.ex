defmodule Filament.Repo do
  use Ecto.Repo,
    otp_app: :filament,
    adapter: Ecto.Adapters.Postgres
end
