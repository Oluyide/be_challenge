defmodule AppWeb.PageController do
  use AppWeb, :controller
  alias App.Model.DataAccess
  alias App.Data.Inventory

  def index(conn, _params) do
    changeset = Inventory.changeset(%Inventory{}, %{})
    inventories = DataAccess.get_all()
    render(conn, "index.html", inventories: inventories, changeset: changeset)
  end

  def create(conn, params) do
    if params["inventory"]["data"].content_type == "text/csv" do
      results =
        params["inventory"]["data"].path
        |> File.stream!()
        |> Stream.map(& &1)
        |> CSV.decode(separator: ?|, headers: true)
        |> Enum.to_list()

      data_list = for {:ok, r} <- results, do: r

      clean_data_set =
        Enum.map(data_list, fn data -> Map.new(data, fn {k, v} -> {String.downcase(k), v} end) end)

      uploaded_partnum = Enum.map(clean_data_set, fn data -> data["part_number"] end)
      available_partnum = Enum.map(DataAccess.get_all(), fn data -> data.part_number end)

      not_in_csv = Enum.filter(available_partnum, fn f -> !Enum.member?(uploaded_partnum, f) end)

      if Enum.empty?(not_in_csv) and Enum.empty?(available_partnum) do
        Enum.each(clean_data_set, fn x -> DataAccess.create_inventories(x) end)
      end

      if !Enum.empty?(not_in_csv) do
        Enum.map(not_in_csv, fn x -> DataAccess.get_item(x) end)
        |> List.flatten()
        |> Enum.each(fn data -> DataAccess.delete_item(data) end)
      end

      in_csv = Enum.filter(available_partnum, fn f -> Enum.member?(uploaded_partnum, f) end)

      if !Enum.empty?(in_csv) do
        for r <- in_csv,
            do:
              Enum.filter(clean_data_set, fn x -> x["part_number"] == r end)
              |> Enum.each(fn data ->
                DataAccess.get_item(data["part_number"])
                |> Enum.at(0)
                |> DataAccess.update_inventories(data)
              end)
      end

      not_in_db = Enum.filter(uploaded_partnum, fn f -> !Enum.member?(available_partnum, f) end)

      for r <- not_in_db,
          do:
            Enum.filter(clean_data_set, fn x -> x["part_number"] == r end)
            |> Enum.each(fn x -> DataAccess.create_inventories(x) end)

      inventories = DataAccess.get_all()

      changeset = Inventory.changeset(%Inventory{}, %{})

      conn
      |> put_flash(:info, "save successfully")
      |> render("index.html", inventories: inventories, changeset: changeset)
    else
      inventories = DataAccess.get_all()
      changeset = Inventory.changeset(%Inventory{}, %{})

      conn
      |> put_flash(:error, "This is a wrong file")
      |> render("index.html", inventories: inventories, changeset: changeset)
    end
  end
end
