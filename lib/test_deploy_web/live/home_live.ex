defmodule TestDeployWeb.HomeLive do
  use TestDeployWeb, :live_view

  alias TestDeploy.Catalog

  @impl true
  def mount(_params, _session, socket) do
    items = Catalog.list_items()
    env_type = if System.get_env("DOKPLOY_DEPLOY_URL"), do: :preview, else: :production
    db_path = System.get_env("DATABASE_PATH", "dev.db")

    {:ok,
     assign(socket,
       items: items,
       env_type: env_type,
       db_path: db_path,
       page_title: "Deploy Test"
     )}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-200 p-8">
      <div class="max-w-2xl mx-auto">
        <div class={[
          "alert mb-8",
          @env_type == :preview && "alert-warning",
          @env_type == :production && "alert-success"
        ]}>
          <span class="text-2xl font-bold">
            <%= if @env_type == :preview do %>
              PREVIEW ENVIRONMENT
            <% else %>
              PRODUCTION ENVIRONMENT
            <% end %>
          </span>
        </div>

        <div class="card bg-base-100 shadow-xl mb-8">
          <div class="card-body">
            <h2 class="card-title">Database Info (PREVIEW CHANGE)</h2>
            <p><strong>Path:</strong> <%= @db_path %></p>
            <p><strong>Items count:</strong> <%= length(@items) %></p>
          </div>
        </div>

        <div class="card bg-base-100 shadow-xl mb-8">
          <div class="card-body">
            <h2 class="card-title">Items in Database</h2>
            <%= if @items == [] do %>
              <p class="text-base-content/60">No items yet</p>
            <% else %>
              <ul class="list-disc list-inside">
                <%= for item <- @items do %>
                  <li><%= item.name %> (ID: <%= item.id %>)</li>
                <% end %>
              </ul>
            <% end %>
            <div class="card-actions justify-end mt-4">
              <.link navigate={~p"/items"} class="btn btn-primary">
                Manage Items
              </.link>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end
end
