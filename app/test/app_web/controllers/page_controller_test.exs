defmodule AppWeb.PageControllerTest do
  use AppWeb.ConnCase
  alias App.Model.DataAccess

  test "When there is no value in database", %{conn: conn} do
    upload = %{
      "_csrf_token" => "LwN1NREUBgInAW9Eegw4OR80D3MQRF8WmbBMhPnPqv-i6UqXglVFE40x",
      "_utf8" => "✓",
      "inventory" => %{
        "data" => %Plug.Upload{
          content_type: "text/csv",
          filename: "data.csv",
          path: "test/data_file/data1/data.csv"
        }
      }
    }

    conn = build_conn() |> post("/", upload)

    response = html_response(conn, 200)
    matches = Regex.named_captures(~r/Saved successfully/, response)

    inventories = DataAccess.get_all()
    assert length(inventories) == 8

    assert response =~ ~r/0121F00548/
    assert response =~ ~r/0121G00047P/
    assert response =~ ~r/GALV x FAB x 0121F00548 x 16093 x .026 x 29.88 x 17.56/
    assert response =~ ~r/TUC/
  end

  test "When  Some values are no more in the CSV", %{conn: conn} do
    upload = %{
      "_csrf_token" => "LwN1NREUBgInAW9Eegw4OR80D3MQRF8WmbBMhPnPqv-i6UqXglVFE40x",
      "_utf8" => "✓",
      "inventory" => %{
        "data" => %Plug.Upload{
          content_type: "text/csv",
          filename: "data.csv",
          path: "test/data_file/data2/data.csv"
        }
      }
    }

    conn = build_conn() |> post("/", upload)

    response = html_response(conn, 200)
    matches = Regex.named_captures(~r/Saved successfully/, response)

    inventories = DataAccess.get_all()
    assert length(inventories) == 4
    assert response =~ ~r/0121G00509/

  end

  test "When more Data are added to the file", %{conn: conn} do
    upload = %{
      "_csrf_token" => "LwN1NREUBgInAW9Eegw4OR80D3MQRF8WmbBMhPnPqv-i6UqXglVFE40x",
      "_utf8" => "✓",
      "inventory" => %{
        "data" => %Plug.Upload{
          content_type: "text/csv",
          filename: "data.csv",
          path: "test/data_file/data3/data.csv"
        }
      }
    }

    conn = build_conn() |> post("/", upload)

    response = html_response(conn, 200)
    matches = Regex.named_captures(~r/Saved successfully/, response)

    inventories = DataAccess.get_all()
    assert length(inventories) == 14
    assert response =~ ~r/0121G00509/
  end

  test "Wrong file extension", %{conn: conn} do
    upload = %{
      "_csrf_token" => "LwN1NREUBgInAW9Eegw4OR80D3MQRF8WmbBMhPnPqv-i6UqXglVFE40x",
      "_utf8" => "✓",
      "inventory" => %{
        "data" => %Plug.Upload{
          content_type: "application/pdf",
          filename: "index.pdf",
          path: "test/data_file/wrongfile/index.pdf"
        }
      }
    }

    conn = build_conn() |> post("/", upload)

    response = html_response(conn, 200)
    matches = Regex.named_captures(~r/This is a wrong file/, response)
  end
end
