defmodule Mh.Performance do
  alias Mh.Performance.ScreenState
  alias Mh.Repo
  alias Mh.Performance.GooeyFaceInpainting
  alias Mh.GooeyApiClient

  def files() do
    # uploads_dir = Path.join([:code.priv_dir(:mh), "static", "uploads"])
    uploads_dir = Path.join(["/uploads"])

    case File.ls(uploads_dir) do
      {:ok, files} -> files
      {:error, :enoent} -> []
    end
  end

  def gooey_files() do
    Repo.all(GooeyFaceInpainting)
    |> Enum.map(fn item -> Map.take(item, GooeyFaceInpainting.__schema__(:fields)) end)
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Mh.PubSub, "screen")
  end

  def create_gooey_face_inpaintings(params) do
    %GooeyFaceInpainting{}
    |> GooeyFaceInpainting.changeset(%{
      src: params.src,
      prompt: params.prompt,
      output: params.output
    })
    |> Repo.insert()
  end

  def get_gooey_face_inpaintings(images) when is_list(images) do
    Enum.map(images, &temp(&1))
  end

  def get_gooey_face_inpaintings(image_id) do
    Repo.get(GooeyFaceInpainting, image_id).output
  end

  def temp(image_id) do
    Repo.get(GooeyFaceInpainting, image_id)
  end

  def update_screen(event) do
    ScreenState.update_state(event)
    Phoenix.PubSub.broadcast(Mh.PubSub, "screen", event)
  end

  def update_vote(id) do
    ScreenState.update_state({:vote, id})
    Phoenix.PubSub.broadcast(Mh.PubSub, "screen", {:vote, id})
  end

  def send_comment(comment) do
    Phoenix.PubSub.broadcast(Mh.PubSub, "screen", {:comment, comment})
  end

  def get_manipulated_image(%{email: email, prompt: prompt}),
    do: GooeyApiClient.email_inpainting(email, prompt)

  def get_manipulated_image(%{image_url: image_url, prompt: prompt}),
    do: GooeyApiClient.image_inpainting(image_url, prompt)
end
