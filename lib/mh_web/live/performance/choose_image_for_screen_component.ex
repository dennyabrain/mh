defmodule MhWeb.Performance.ChooseImageForScreenComponent do
  alias Mh.Performance
  use MhWeb, :live_component

  def update(assigns, socket) do
    socket =
      case Performance.gooey_files() do
        files -> assign(socket, :media_files, files)
      end

    {:ok, socket}
  end

  def handle_event("selection_change", params, socket) do
    socket = socket |> assign(:current_photo, String.to_integer(params["value"]))
    {:noreply, socket}
  end

  def handle_event("send_to_screen", _params, socket) do
    photo_id = socket.assigns.current_photo
    # event = {:manipulated_image, %{image_id: photo_id}}
    event =
      {:manipulated_image, %{image_id: photo_id}}

    Performance.update_screen(event)
    {:noreply, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Choose Image</h1>
      <div :if={@media_files} class="mt-4 bg-slate-200 p-4 flex flex-row gap-8 overflow-scroll">
        <%= for file <- @media_files do %>
          <div class="flex flex-col gap-2">
            <input
              type="checkbox"
              id={"#{file.id}"}
              name={"#{file.id}"}
              value={"#{file.id}"}
              phx-click="selection_change"
              phx-target={@myself}
            />
            <img class="h-24 w-24" src={file.output} />
            <p class="text-xs w-24"><%= file.prompt %></p>
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
