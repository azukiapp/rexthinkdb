defmodule Rethinkdb.Connection.Options.Test do
  use Rethinkdb.Case
  alias Rethinkdb.Connection.Options, as: Options

  test "check a default values for new optionsection" do
    options = Options.new

    assert "localhost" == options.host
    assert 28015 == options.port
    assert ""    == options.authKey
    assert 20    == options.timeout
    assert nil   == options.db
  end

  test "support create with uri" do
    options = Options.new("rethinkdb://auth_key@remote:28106/rethinkdb_test")

    assert "remote" == options.host
    assert 28106    == options.port
    assert "rethinkdb_test" == options.db
    assert "auth_key" == options.authKey

    default = Options.new
    options    = Options.new("rethinkdb://remote:28106")
    assert default.db == options.db
    assert default.authKey == options.authKey

    options = Options.new("rethinkdb://remote")
    assert default.port == options.port
  end

  test "return error for invalid uri optionsect" do
    {:error, msg} = Options.new("")
    assert is_binary(msg)
    {:error, msg} = Options.new("http://example.com")
    assert is_binary(msg)
  end
end
