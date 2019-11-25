defmodule Ares.Post do
  use Ecto.Schema
  import Ecto.Changeset

  schema "posts" do
  end

  @doc false
  def changeset(struct, attrs) do
    struct
    |> cast(attrs, [:title])
    #|> validate_required([])
  end
end
