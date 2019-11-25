defmodule(Ares.Repo.Migrations.FirstMig) do
  use(Ecto.Migration)
  def(change) do
    create_if_not_exists(table("posts"))
    alter(table("posts")) do
      [add(:title, :string)]
    end
  end
end