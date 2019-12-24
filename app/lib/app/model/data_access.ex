defmodule App.Model.DataAccess do
  alias App.Repo
  alias App.Data.Inventory
  import Ecto.Query, only: [from: 2]

  def create_inventories(attrs \\ %{}) do
    %Inventory{}
    |> Inventory.changeset(attrs)
    |> Repo.insert()
  end

  def get_items_with_part_num(part_number), do: Repo.get!(Inventory, part_number)

  def get_item(part_number) do
    item =
      from(p in Inventory,
        where: p.part_number == ^part_number
      )

    Repo.all(item)
  end



  def get_all() do
    Repo.all(Inventory)
  end

  def delete_item(%Inventory{} = inventory) do
    Repo.delete(inventory)
  end

  def update_inventories(%Inventory{} = inventory, attrs) do
    inventory
    |> Inventory.changeset(attrs)
    |> Repo.update()
  end
end
