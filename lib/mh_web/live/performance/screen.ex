defmodule MhWeb.Live.Performance.Screen do
  @moduledoc """

  ## Showing Poll
  payload example
  %{
    images: [url_1, url_2]
  }
  """

  alias Mh.Performance
  use MhWeb, :live_view
  use MhWeb, :html

  def mount(_params, _session, socket) do
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

  def handle_info({:manipulated_image, payload}, socket) do
    IO.inspect("received event for manipulated image, #{inspect(payload)}")

    socket =
      socket
      |> assign(:type, :manipulated_image)
      |> assign(:payload, payload)

    {:noreply, socket}
  end
end
