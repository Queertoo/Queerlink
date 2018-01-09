defmodule Queerlink do
  @moduledoc false


  defdelegate insert(url),  to: Queerlink.Shortener
  defdelegate lookup(hash), to: Queerlink.Shortener

  defmodule Release do
    require Logger

    @start_apps [:queerlink, :phoenix_ecto, :sqlite_ecto2, :sqlitex, :esqlite, :ecto, :poolboy, :decimal, :db_connection, :connection, :phoenix_live_reload, :file_system,
                 :phoenix_html, :cowboy, :cowlib, :ranch, :norma, :ex_doc, :earmark, :hashids, :runtime_tools, :logger, :gettext, :phoenix, :phoenix_pubsub, :eex, :poison,
                 :plug, :mime, :hex, :inets, :ssl, :public_key, :asn1, :crypto, :mix, :iex, :elixir, :compiler, :stdlib, :kernel, :logger
                ]



    def repos, do: Application.get_env(:queerlink, :ecto_repos, [])

    def seed do
      Application.start(:logger)

      Logger.info "Starting Queerlink"
      # Load the code for :queerlink, but don't start it
      :ok = Application.load(:queerlink)

      Logger.info "Starting dependencies.."
      # Start apps necessary for executing migrations
      Enum.each(@start_apps, &Application.ensure_all_started/1)

      # Start the Repo(s) for :queerlink
      Logger.info "Starting repos.."
      Enum.each(repos(), &(&1.start_link(pool_size: 1)))

      # Run migrations
      migrate()

      # Run seed script
      Enum.each(repos(), &run_seeds_for/1)

      # Signal shutdown
      Logger.info "Success!"
      :init.stop()
    end

    def migrate, do: Enum.each(repos(), &run_migrations_for/1)

    def priv_dir(app), do: "#{:code.priv_dir(app)}"

    defp run_migrations_for(repo) do
      app = Keyword.get(repo.config, :otp_app)
      Logger.info "Running migrations for #{app}"
      Ecto.Migrator.run(repo, migrations_path(repo), :up, all: true)
    end

    def run_seeds_for(repo) do
      # Run the seed script if it exists
      seed_script = seeds_path(repo)
      if File.exists?(seed_script) do
        Logger.info "Running seed script.."
        Code.eval_file(seed_script)
      end
    end

    def migrations_path(repo), do: priv_path_for(repo, "migrations")

    def seeds_path(repo), do: priv_path_for(repo, "seeds.exs")

    def priv_path_for(repo, filename) do
      app = Keyword.get(repo.config, :otp_app)
      repo_underscore = repo |> Module.split |> List.last |> Macro.underscore
      Path.join([priv_dir(app), repo_underscore, filename])
    end
  end
end
