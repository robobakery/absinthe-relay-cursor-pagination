defmodule Pagi.Blog.Post do
  use Ecto.Schema
  import Ecto.Changeset


  schema "posts" do
    field :name, :string
    field :total_post_views, :integer

    timestamps()
  end

  @doc false
  def changeset(post, attrs) do
    post
    |> cast(attrs, [:name, :total_post_views])
    |> validate_required([:name, :total_post_views])
  end
end
