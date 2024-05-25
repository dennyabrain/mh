defmodule Mh.Repo do
  use Ecto.Repo,
    otp_app: :mh,
    adapter: Ecto.Adapters.Postgres
end
