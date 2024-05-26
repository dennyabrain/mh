defmodule Mh.Performance do
  alias Mh.GooeyApiClient

  def files() do
    uploads_dir = Path.join([:code.priv_dir(:mh), "static", "uploads"])

    case File.ls(uploads_dir) do
      {:ok, files} -> files
      {:error, :enoent} -> []
    end
  end

  def subscribe() do
    Phoenix.PubSub.subscribe(Mh.PubSub, "screen")
  end

  def update_screen() do
    event = {:poll, %{images: ["a", "b"]}}
    Phoenix.PubSub.broadcast(Mh.PubSub, "screen", event)
  end

  def get_manipulated_image(%{email: email, prompt: prompt}),
    do: GooeyApiClient.email_inpainting(email, prompt)

  def get_manipulated_image(%{image_url: image_url, prompt: prompt}),
    do: GooeyApiClient.image_inpainting(image_url, prompt)
end
