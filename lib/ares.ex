defmodule Ares do
  @moduledoc """
  Ares is a simple Data Moddler, where you can generate dynamic models.
  """

  def gen_schema(module, table, fields) do
    Module.create(module,
    quote do
      use Ecto.Schema

      schema unquote(table) do
        unquote(for {name, type} <- fields do
          quote do
            field unquote(name), unquote(type)
          end
        end)
      end

    end,
    Macro.Env.location(__ENV__))
  end

  def gen_migration_file(name) when is_binary(name) do
    case System.cmd("mix", ["ecto.gen.migration", name]) do
      {result, 0} -> {:ok, require_migration(result)}
      _ ->  {:error, "Could not complete request!"}
    end
  end
  def migration(_), do: {:error, "Migration name must be string!"}

  defp require_migration(str) do
    # get full migration path
    "* creating " <> migration = str |> String.trim_trailing("\n")
    migr_file = Path.basename(migration)
    migr_path = Path.join(Ecto.Migrator.migrations_path(Ares.Repo), migr_file)
    # require migration file
    [{migr_module, _}] = Code.require_file(migr_path, File.cwd!)
    {migr_path, migr_module}
  end

  def gen_migration_code({:ok, {migr_path, migr_module}}, table, fields) do
    contents =
      quote do
        defmodule unquote(migr_module) do

        use Ecto.Migration

          def change do
            create_if_not_exists table(unquote(table))
            alter table(unquote(table)) do
              unquote(for {name, type} <- fields do
                quote do
                  add unquote(name), unquote(type)
                end
              end)
            end
          end
        end
      end
    File.write(migr_path, contents |> Macro.to_string)
  end

  #def run_migration, do: Ecto.Migrator.run(Ares.Repo, :up, :all)
  def run_migration, do: System.cmd("mix", ["ecto.migrate"])
  # Ares.go(Ares.Post, "posts", [{:title, :string}], "first_mig")

  @doc """
  ## Examples

      iex> Ares.go(Ares.Post, "posts", [{:title, :string}])
      # MyPost is now just like any other Schema module in Phoenix.
      # IO.inspect MyApp.Repo.all(MyPost)

  """

  def go(module, table, fields, migration_name) do
    gen_schema(module, table, fields)
    gen_migration_file(migration_name)
    |> gen_migration_code(table, fields)
    run_migration()
  end

end

# Ecto.Migrator.run(repo, Ecto.Migrator.migrations_path(repo), direction, opts)


### PLAN ###
## schemaless (query example down below)
#  [%{id: id}] = Ares.Repo.insert_all "posts", [[title: "hello"]], returning: [:id]
#  post = from p in "posts", where: p.id == ^id
#  {1, _} = MyApp.Repo.update_all post, set: [title: "new title"]
#  {1, _} = MyApp.Repo.delete_all post

## create migration module using macros ## GL macroying this
# use Ecto.Migration
#   create_if_not_exists table("version") do end
#   alter table("posts") do
#     add :parameter, :type
#     modify, remove...
#   end

## use migrator to run the migration ##
# Ecto.Migrator.run(Ares.Repo, :up or :down, :all)

# Mix.Task.run "ecto.drop", []


# query example
# import Ecto.Query
# MyApp.Repo.all(
#   from u in "users",
#   join: a in "activities",
#   on: a.user_id == u.id,
#   where: a.start_at > type(^start_at, Ecto.DateTime) and
#          a.end_at < type(^end_at, Ecto.DateTime),
#   group_by: a.user_id,
#   select: %{user_id: a.user_id, interval: a.start_at - a.end_at, count: count(u.id)}
# )
