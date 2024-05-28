defmodule MhWeb.Live.Performance.Screen do
  @moduledoc """

  ## Showing Poll
  payload example
  %{
    images: [url_1, url_2]
  }
  """

  alias Mh.Performance.ScreenState
  alias Mh.Performance
  use MhWeb, :live_view
  use MhWeb, :html

  def mount(_params, _session, socket) do
    if connected?(socket), do: Performance.subscribe()

    socket =
      case ScreenState.get_state() do
        %{} ->
          socket |> assign(:type, nil) |> assign(:payload, nil)

        {:poll, payload} ->
          score = Enum.reduce(payload.photos, %{}, fn i, acc -> Map.put(acc, i, 0) end)

          socket
          |> assign(:type, :poll)
          |> assign(:photos, payload.photos)
          |> assign(:score, score)

        {:manipulated_image, payload} ->
          socket
          |> assign(:type, :manipulated_image)
          |> assign(:comments, [])
          |> assign(:payload, payload)

        {type, payload} ->
          socket |> assign(:type, type) |> assign(:payload, payload)
      end

    {:ok, socket}
  end

  def handle_info({:poll, payload}, socket) do
    IO.inspect("received poll #{inspect(payload)}")
    photo_ids = payload.photos
    score = Enum.reduce(photo_ids, %{}, fn i, acc -> Map.put(acc, i, 0) end)

    photos = Performance.get_gooey_face_inpaintings(photo_ids)

    socket =
      socket
      |> assign(:type, :poll)
      |> assign(:photos, photos)
      |> assign(:score, score)

    {:noreply, socket}
  end

  def handle_info({:vote, id}, socket) do
    IO.inspect("voted for #{id}")
    current_score = socket.assigns.score
    current_vote = current_score[id]
    new_score = Map.put(current_score, id, current_vote + 1) |> IO.inspect()
    {:noreply, assign(socket, :score, new_score)}
  end

  def handle_info({:comment, comment}, socket) do
    current_comments = socket.assigns.comments
    new_comments = [comment] ++ current_comments
    {:noreply, assign(socket, :comments, new_comments)}
  end

  def handle_info({:manipulated_image, payload}, socket) do
    IO.inspect("received event for manipulated image, #{inspect(payload)}")

    socket =
      socket
      |> assign(:type, :manipulated_image)
      |> assign(:payload, payload)

    {:noreply, socket}
  end

  def handle_info(%{}, socket) do
    socket = socket |> assign(:type, nil) |> assign(:payload, nil)

    {:noreply, socket}
  end
end
