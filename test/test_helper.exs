ExUnit.start

defmodule Rethinkdb.Case do
  use ExUnit.CaseTemplate
  use Rethinkdb

  using _ do
    quote do
      import unquote(__MODULE__)
    end
  end

  def dbns, do: "elixir_drive_test"

  def connect(tables) do
    connect(tables, [])
  end

  def connect(tables, table_opts) when is_list(tables) do
    conn   = r.connect(db: "#{dbns}")
    db     = r.db(conn.db)

    info_or_create(db, r.db_create(conn.db), conn)
    Enum.each(tables, fn table ->
      db.table_drop(table).run(conn)
      db.table_create(table, table_opts).run!(conn)
    end)

    {conn, tables}
  end

  def connect(table, table_opts) do
    {conn, _} = connect([table], table_opts)
    {conn, table}
  end

  defp info_or_create(info, create, conn) do
    try do
      info.info.run!(conn)
    rescue
      RqlRuntimeError ->
        create.run!(conn)
    end
  end

  # Debug in tests
  def pp(value), do: IO.inspect(value)
end
