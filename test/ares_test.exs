defmodule AresTest do
  use ExUnit.Case
  doctest Ares

  test "greets the world" do
    assert Ares.hello() == :world
  end
end
