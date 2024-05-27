defmodule MhWeb.Live.Performance.Participant do
  alias Mh.Performance
  use MhWeb, :live_view
  use MhWeb, :html

  def mount(params, session, socket) do
    if connected?(socket), do: Performance.subscribe()
    socket = socket |> assign(:type, nil) |> assign(:payload, nil)

    {:ok, socket}
  end

  def handle_info({:poll, payload}, socket) do
    photo_ids = payload.photos

    photos = Performance.get_gooey_face_inpaintings(photo_ids)

    socket =
      socket
      |> assign(:type, :poll)
      |> assign(:photos, photos)

    {:noreply, socket}
  end

  def handle_event("vote", params, socket) do
    IO.inspect(params)
    Performance.update_vote(String.to_integer(params["id"]))

    {:noreply, socket}
  end
end
