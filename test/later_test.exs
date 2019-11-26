defmodule LaterTest do
  use ExUnit.Case
  doctest Later

  test "greets the world" do
    assert Later.hello() == :world
  end
end
