defmodule Pagi.Repo.Migrations.CreatePosts do
  use Ecto.Migration

  def change do
    create table(:posts) do
      add :name, :string
      add :total_post_views, :integer

      timestamps()
    end

  end
end
