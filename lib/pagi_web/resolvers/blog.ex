defmodule PagiWeb.Resolvers.Blog do
  import Ecto.Query

  alias Pagi.Repo
  alias Pagi.Blog
  alias Pagi.Blog.Post

  def trending_posts(_, args, _) do
    args = Map.put(args, :order_by, %{sort_order: :desc, field: :total_post_views})

    Absinthe.Relay.Connection.from_query(
      Blog.posts_query(args),
      &Pagi.Repo.all/1,
      args
    )
  end

  def reset(_, _, _) do
    existing_posts =
      Post |> order_by(asc: :id) |> Repo.all()
 
    existing_posts
    |> Enum.each(fn post ->
      Blog.update_post(post, %{total_post_views: post.id * 100})
    end)

    {:ok, true}
  end

  def simulate(_, _, _) do
    most_unpopular_post =
      Post |> order_by(asc: :total_post_views) |> limit(1) |> Repo.one()

    most_popular_two =
      Post |> order_by(desc: :total_post_views) |> limit(2) |> Repo.all()

    total_to_be_second =
      get_avg_total_post_views(Enum.at(most_popular_two, 0), Enum.at(most_popular_two, 1))

    Blog.update_post(most_unpopular_post, %{total_post_views: total_to_be_second})

    {:ok, true}
  end

  def update_post(_, %{id: id, post: post_attrs}, _) do
    with %Post{} = post <- Blog.get_post!(id),
         {:ok, updated_post} <- Blog.update_post(post, post_attrs) do
      {:ok, updated_post}
    else
      _ ->
        {:error, "something wrong"}
    end
  end

  defp get_avg_total_post_views(%{total_post_views: a}, %{total_post_views: b}) do
    Integer.floor_div(a + b, 2)
  end
end