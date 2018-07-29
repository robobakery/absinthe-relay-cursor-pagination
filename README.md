# Pagi

this is an example of relay style cursor based pagination with elixir, phoenix, absinthe.

i'm sharing this to discuss about one possible problem in such condition:
- pagination of sorted data
- & the key used for sorting can be updated (e.g. total_post_views)
- if updates happens while you're navigating (it means query comes after an update)
- some of your data will not appear in your list (PROBLEM!)
- how to handle this?

To start:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.create && mix ecto.migrate`
  * Install Seed data of this project `mix run priv/repo/seeds.exs`
  * Start Phoenix endpoint with `mix phx.server`

Graphiql:

Now you can visit [`localhost:4000/graph/graphiql`](http://localhost:4000) from your browser.

## Scenario of this project?
- there will be 10 posts and each has 100, 200, ..., 1000 total_post_views
- paginate first 5 trending posts (order_by desc: total_post_views)
- simulate! (most unpopular post will take the 2nd position)
- continue to paginate first 5 trending posts, after "YXJyYXljb25uZWN0aW9uOjQ=" (5th)
- you will see one post (which has been boosted) is not in your list (PROBLEM!)

Queries:

  * trending_posts: list trending_posts (order_by desc: :total_post_views)

Mutations:

  * reset: reset all data as same as seeds.exs
  * simulate: simluate scenario: make 'most unpopular post' be a second one
  * update_post: you can manually update post for testing

## Examples:

Page 1:
```
{
  trendingPosts(first: 5) {
    edges {
      node {
        name
        totalPostViews
      }
      cursor
    }
  }
}
```

Page 2:
```
{
  trendingPosts(first: 5, after: "YXJyYXljb25uZWN0aW9uOjQ=") {
    edges {
      node {
        name
        totalPostViews
      }
      cursor
    }
  }
}
```

Simulate:
```
mutation {
  simulate
}
```

Reset:
```
mutation {
  reset
}
```

Update Post:
```
mutation {
  updatePost(id: 1, post: {totalPostViews: 100}) {
    name
    totalPostViews
  }
}
```