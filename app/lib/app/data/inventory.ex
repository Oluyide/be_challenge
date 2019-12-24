defmodule App.Data.Inventory do
  use Ecto.Schema
  import Ecto.Changeset

  schema "inventories" do
    field(:part_number, :string)
    field(:branch_id, :string)
    field(:part_price, :float)
    field(:short_desc, :string)
    timestamps()
  end

  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:part_number, :branch_id, :part_price, :short_desc])
    |> validate_required([:part_number, :branch_id, :part_price, :short_desc])
    |> unique_constraint(:part_number)
  end
end
