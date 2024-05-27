defmodule Mh.Repo.Migrations.CreateGooeyFaceInpaintings do
  use Ecto.Migration

  def change do
    create table(:gooey_face_inpaintings) do
      add :src, :string
      add :prompt, :string
      add :output, :string

      timestamps(type: :utc_datetime)
    end
  end
end
