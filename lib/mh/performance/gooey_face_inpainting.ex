defmodule Mh.Performance.GooeyFaceInpainting do
  alias Mh.Performance.GooeyFaceInpainting
  use Ecto.Schema
  import Ecto.Changeset

  # @derive {Jason.Encoder, except: [:__meta__, :__struct__]}
  schema "gooey_face_inpaintings" do
    field :output, :string
    field :prompt, :string
    field :src, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gooey_face_inpainting, attrs) do
    gooey_face_inpainting
    |> cast(attrs, [:src, :prompt, :output])
    |> validate_required([:src, :prompt, :output])
  end

  def create_in_ui_changeset(attrs) do
    %GooeyFaceInpainting{}
    |> cast(attrs, [:src, :prompt])
    |> validate_required([:src, :prompt])
  end
end
