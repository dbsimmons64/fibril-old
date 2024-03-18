defmodule Fibril.Repo do
  use Ecto.Repo,
    otp_app: :fibril,
    adapter: Ecto.Adapters.Postgres
end
