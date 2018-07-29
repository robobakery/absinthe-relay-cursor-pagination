counts = 10

# Posts
for idx <- 1..counts do
  %Pagi.Blog.Post{
    name: "Post ##{idx}",
    total_post_views: idx * 100
  }
  |> Pagi.Repo.insert!
end