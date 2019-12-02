defmodule LaterTest do
  use ExUnit.Case
  alias Later.CLI
  doctest Later

  setup_all do
    IO.puts("Starting test..")
  end

  test "help" do
    assert CLI.main(["-h"]) == :ok
  end

  test "add" do
    assert CLI.main(["-a", "I hope it works.", "Hello."]) == :ok
  end

  test "show all" do
    assert CLI.main(["-s"]) == :ok
  end

  test "show" do
    assert CLI.main(["-s", "1"]) == :ok
  end

  test "edit" do
    assert CLI.main(["-e", "1", "I am error."]) == :ok
  end

  test "delete" do
    assert CLI.main(["-d", "1"]) == :ok
  end
end
