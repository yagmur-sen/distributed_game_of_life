defmodule DistributedGameOfLifeTest do
  use ExUnit.Case
  doctest DistributedGameOfLife

  test "greets the world" do
    assert DistributedGameOfLife.hello() == :world
  end
end
