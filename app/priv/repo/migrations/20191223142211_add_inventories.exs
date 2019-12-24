defmodule App.Repo.Migrations.AddInventories do
  use Ecto.Migration

  def change do
    create table(:inventories) do
      add(:part_number, :string)
      add(:branch_id, :string)
      add(:part_price, :float)
      add(:short_desc, :string)
      add(:is_deleted, :boolean)
      timestamps()
    end
    create unique_index(:inventories, [:part_number])
  end
end
