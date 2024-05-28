defmodule MhWeb.Performance.ShowPollComponent do
  alias Mh.Performance
  use MhWeb, :live_component

  def update(assigns, socket) do
    socket =
      case Performance.gooey_files() do
        files ->
          assign(socket, :media_files, files)
          |> assign(:photos, [])
          |> assign(:error, nil)
      end

    {:ok, socket}
  end

  def handle_event("selection_change", params, socket) do
    photo_id = String.to_integer(params["value"])
    current_ids = socket.assigns.photos
    new_ids = (current_ids ++ [photo_id]) |> IO.inspect()
    socket = socket |> assign(:photos, new_ids)
    {:noreply, socket}
  end

  def handle_event("send_to_screen", _params, socket) do
    photos = socket.assigns.photos
    # event = {:manipulated_image, %{image_id: photo_id}}
    event =
      {:poll, %{photos: photos}}

    Performance.update_screen(event)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Do Poll</h1>
      <div
        :if={@media_files}
        class="mt-4 bg-slate-200 p-4 flex flex-row flex-wrap gap-8 overflow-scroll"
      >
        <%= for file <- @media_files do %>
          <div class="flex flex-col gap-2">
            <input
              type="checkbox"
              id={"#{file.id}"}
              name="photos"
              value={"#{file.id}"}
              checked={file.id in @photos}
              phx-click="selection_change"
              phx-target={@myself}
            />
            <img class="h-24 w-24" src={file.output} />
            <p class="text-xs w-24"><%= file.prompt %></p>
          </div>
          <div :if={@error}>
            <p class="text-red-500"><%= @error %></p>
          </div>
        <% end %>
      </div>
      <button class="p-2 bg-red-500 rounded-md" phx-click="send_to_screen" phx-target={@myself}>
        Send to screen
      </button>
    </div>
    """
  end
end
