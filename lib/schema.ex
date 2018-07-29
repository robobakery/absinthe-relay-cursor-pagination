defmodule PagiWeb.Schema do
  use Absinthe.Schema
  use Absinthe.Relay.Schema, :modern
  use Absinthe.Relay.Schema.Notation, :modern

  alias PagiWeb.Resolvers

  connection node_type: :post

  node object :post do
    field :name, :string
    field :total_post_views, :integer
  end

  input_object :post_params do
    field :name, :string
    field :total_post_views, :integer
  end

  node interface do
    resolve_type fn
      %Pagi.Blog.Post{}, _ ->
        :post
      _, _ ->
        nil
   end
  end

  query do
    node field do
      resolve fn
        %{type: :post, id: local_id}, _ ->
          {:ok, Pagi.Repo.get(Agg.Blog.Post, local_id)}
        _, _ ->
          {:error, "Unknown node"}
      end
    end

    @desc "list trending_posts (order_by desc: :total_post_views)"
    connection field :trending_posts, node_type: :post do
      resolve &Resolvers.Blog.trending_posts/3
    end
  end

  mutation do
    @desc "reset all data as same as seeds.exs"
    field :reset, :boolean do
      resolve &Resolvers.Blog.reset/3
    end

    @desc "simluate scenario: make 'most unpopular post' be a second one"
    field :simulate, :boolean do
      resolve &Resolvers.Blog.simulate/3
    end

    @desc "you can manually update post for testing"
    field :update_post, :post do
      arg :id, :id
      arg :post, :post_params

      resolve &Resolvers.Blog.update_post/3
    end
  end
end