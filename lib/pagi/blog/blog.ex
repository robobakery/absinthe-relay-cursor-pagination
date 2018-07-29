defmodule Pagi.Blog do
  @moduledoc """
  The Blog context.
  """

  import Ecto.Query, warn: false
  alias Pagi.Repo

  alias Pagi.Blog.Post

  def posts_query(args) do
    Enum.reduce(args, Post, fn
      {:order_by, %{sort_order: sort_order, field: field}}, query ->
        query |> order_by({^sort_order, ^field})
      _, query ->
        query
    end)
  end

  def get_post!(id), do: Repo.get!(Post, id)

  def create_post(attrs \\ %{}) do
    %Post{}
    |> Post.changeset(attrs)
    |> Repo.insert()
  end

  def update_post(%Post{} = post, attrs) do
    post
    |> Post.changeset(attrs)
    |> Repo.update()
  end
end
