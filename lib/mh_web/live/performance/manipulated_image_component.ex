defmodule MhWeb.Performance.ManipulatedImageComponent do
  alias Mh.Performance
  use MhWeb, :live_component

  def handle_event("create_gooey_face_inpainting", params, socket) do
    {:noreply, socket}
  end

  def handle_event("selection_change", params, socket) do
    %{"value" => src} = params

    new_form =
      socket.assigns.raw_form
      |> Map.put("src", src)

    socket = socket |> assign(:form, to_form(new_form))

    {:noreply, socket}
  end

  def handle_event("validate", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    {:noreply, socket}
  end

  def handle_event("save", unsigned_params, socket) do
    IO.inspect(unsigned_params)
    # IO.inspect(socket.assigns.form)
    user_params = Map.merge(socket.assigns.form.params, unsigned_params)
    src = user_params["src"]
    prompt = user_params["prompt"]
    base_url = Application.get_env(:mh, :file_server_base_url)
    src_url = "#{base_url}/#{src}" |> IO.inspect()

    socket =
      case(Performance.get_manipulated_image(%{image_url: src_url, prompt: prompt})) do
        {:ok, url} ->
          Performance.create_gooey_face_inpaintings(%{src: src, prompt: prompt, output: url})

          socket
          |> put_flash(:info, "created successfully")
          |> push_navigate(to: ~p"/show/manager")

        {:error, reason} ->
          socket
          |> assign(:error, "unable to create inpainting")
      end

    {:noreply, socket}
  end

  def update(assigns, socket) do
    files = Performance.files()
    form_fields = %{"src" => "", "prompt" => ""}

    socket =
      socket
      |> assign(:media_files, files)
      |> assign(:raw_form, form_fields)
      |> assign(:error, nil)
      |> assign(:form, to_form(form_fields))

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <div>
      <h1>Create Manipulated Images</h1>

      <div class="mt-4 bg-slate-200 p-4 flex flex-row flex-wrap gap-8 overflow-scroll">
        <%= for file <- @media_files do %>
          <div class="flex flex-col gap-2">
            <img class="h-24 w-24" src={"/uploads/#{file}"} />
            <input
              type="checkbox"
              id={file}
              name={file}
              value={file}
              phx-click="selection_change"
              phx-target={@myself}
            />
          </div>
        <% end %>
      </div>

      <div class="mt-4">
        <.simple_form for={@form} phx-submit="save" phx-validate="validate" phx-target={@myself}>
          <.input field={@form[:src]} label="Source Image" disabled />
          <.input field={@form[:prompt]} label="Prompt" />
          <p :if={@error} class="text-red-800"><%= @error %></p>
          <:actions>
            <.button>Save</.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end
end
