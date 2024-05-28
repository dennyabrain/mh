defmodule MhWeb.Live.Performance.Participant do
  alias Mh.Performance.ScreenState
  alias Mh.Performance
  use MhWeb, :live_view
  use MhWeb, :html

  def mount(params, session, socket) do
    if connected?(socket), do: Performance.subscribe()

    socket =
      case ScreenState.get_state() do
        %{} ->
          socket |> assign(:type, nil) |> assign(:payload, nil)

        {:poll, payload} ->
          # score = Enum.reduce(payload.photos, %{}, fn i, acc -> Map.put(acc, i, 0) end)

          socket
          |> assign(:type, :poll)
          |> assign(:photos, payload.photos)

        {:manipulated_image, payload} ->
          form_fields = %{"comment" => ""}

          socket
          |> assign(:type, :manipulated_image)
          |> assign(:comments, [])
          |> assign(:payload, payload)
          |> assign(:form, to_form(form_fields))

        # |> assign(:score, score)

        {type, payload} ->
          socket |> assign(:type, type) |> assign(:payload, payload)
      end

    # socket = socket |> assign(:type, nil) |> assign(:payload, nil)

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

  def handle_event("send_comment", params, socket) do
    IO.inspect(params)
    form_fields = %{"comment" => ""}

    socket =
      socket |> push_navigate(to: ~p"/show/participant")

    {:noreply, socket}
  end
end
