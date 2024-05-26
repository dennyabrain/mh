defmodule Mh.Performance do
  def files() do
    uploads_dir = Path.join([:code.priv_dir(:mh), "static", "uploads"])
    {:ok, files} = File.ls(uploads_dir)
    files
  end

  def get_manipulated_image(_image_url, _prompt) do
    gooey_key = Application.get_env(:mh, :gooey) |> Keyword.get(:api_key)
    gooey_api_endpoint = "https://api.gooey.ai/v2/FaceInpainting/"

    headers = [
      {"Content-Type", "application/json"},
      {"Authorization", "Bearer #{gooey_key}"}
    ]

    body_struct = %{
      input_image:
        "https://f9f9-2401-4900-1c89-7ff-fb22-c02f-65ac-89c1.ngrok-free.app/uploads/live_view_upload-1716640300-182529340732-1",
      text_prompt:
        "A woman wearing christmas-y sweater and a santa hat sipping a small glass of mulled wine, with bokeh effect of christmas tree and christmas lighting"
    }

    {:ok, body} = Jason.encode(body_struct)

    IO.inspect(headers)
    IO.inspect(body)

    HTTPoison.post(gooey_api_endpoint, body, headers, [])
  end
end
