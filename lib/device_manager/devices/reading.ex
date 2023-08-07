defmodule DeviceManager.Reading do
  use Ecto.Schema
  import Ecto.Changeset

  schema "readings" do
    field :count, :integer
    field :timestamp, :string

    belongs_to :device, DeviceManager.Device
    timestamps()
  end

  @integer_regex ~r/^-?\d+$/
  @timestamp_regex ~r/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})?$/

  @doc false
  def changeset(reading, attrs) do
    reading
    |> cast(attrs, [:timestamp, :count])
    |> validate_required([:timestamp, :count])
    |> assoc_constraint(:device)
    |> validate_number(:count, message: "must be a number")
    |> validate_format(:timestamp, @timestamp_regex)
  end
end
