defmodule DeviceManager.Devices.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    field :count, :integer
    field :timestamp, :utc_datetime

    timestamps()
  end

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:timestamp, :count])
    |> validate_required([:timestamp, :count])
  end
end
