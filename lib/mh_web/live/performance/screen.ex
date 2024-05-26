defmodule MhWeb.Live.Performance.Screen do
  alias Mh.Performance
  use MhWeb, :live_view
  use MhWeb, :html

  def mount(_params, _session, socket) do
    if connected?(socket), do: Performance.subscribe()
    socket = socket |> assign(:payload, nil)

    {:ok, socket}
  end

  def handle_info({:poll, payload}, socket) do
    socket =
      socket
      |> assign(:payload, payload)

    {:noreply, socket}
  end
end
