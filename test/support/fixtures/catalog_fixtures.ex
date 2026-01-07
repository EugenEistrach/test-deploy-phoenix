defmodule TestDeploy.CatalogFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `TestDeploy.Catalog` context.
  """

  @doc """
  Generate a item.
  """
  def item_fixture(attrs \\ %{}) do
    {:ok, item} =
      attrs
      |> Enum.into(%{
        name: "some name"
      })
      |> TestDeploy.Catalog.create_item()

    item
  end
end
