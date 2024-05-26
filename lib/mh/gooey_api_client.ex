defmodule Mh.GooeyApiClient do
  @email_face_inpainting_endpoint "https://api.gooey.ai/v2/EmailFaceInpainting/"
  @image_face_inpainting_endpoint "https://api.gooey.ai/v2/FaceInpainting/"
  @timeout_duration 45_000

  def email_inpainting(email, prompt) do
    gooey_key = Application.get_env(:mh, :gooey) |> Keyword.get(:api_key)

    response =
      Req.post(@email_face_inpainting_endpoint,
        json: %{
          email_address: email,
          text_prompt: prompt
        },
        headers: %{authorization: "Bearer #{gooey_key}", content_type: "application/json"},
        receive_timeout: @timeout_duration
      )

    case response do
      {:ok, data} ->
        image_url = data.body["output"]["output_images"] |> hd
        {:ok, image_url}

      {:error, reason} ->
        IO.inspect(reason)
        {:error, "Failed to get image from gooey"}
    end
  end

  def image_inpainting(image_url, prompt) do
    gooey_key = Application.get_env(:mh, :gooey) |> Keyword.get(:api_key)

    response =
      Req.post(@image_face_inpainting_endpoint,
        json: %{
          input_image: image_url,
          text_prompt: prompt
        },
        headers: %{authorization: "Bearer #{gooey_key}", content_type: "application/json"},
        receive_timeout: @timeout_duration
      )

    case response do
      {:ok, data} ->
        image_url = data.body["output"]["output_images"] |> hd
        {:ok, image_url}

      {:error, reason} ->
        IO.inspect(reason)
        {:error, "Failed to get image from gooey"}
    end
  end
end
