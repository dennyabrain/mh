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
    socket =
      socket
      |> assign(:type, :poll)
      |> assign(:payload, payload)

    {:noreply, socket}
  end

  def handle_event("vote", unsigned_params, socket) do
    IO.inspect(unsigned_params)

    {:noreply, socket}
  end
end
