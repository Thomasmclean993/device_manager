defmodule DeviceManager.Repo do
  use Ecto.Repo,
    otp_app: :device_manager,
    adapter: Ecto.Adapters.Postgres
end
