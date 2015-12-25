defmodule MapEQC do
  use ExUnit.Case
  use EQC.ExUnit

  # NOTE: Strange that this should fail but doesn't.
  property "keys are unique (take 1)" do
    forall m <- map_1 do
      no_duplicates(Map.keys(m))
    end
  end

  property "keys are unique (take 2)" do
    forall m <- map_2 do
      no_duplicates(Map.keys(:eqc_symbolic.eval(m)))
    end
  end

  property "storing keys and values" do
    forall {k, v, m} <- {key, val, map_2} do
      map = :eqc_symbolic.eval(m)
      equal(model(Map.put(map, k, v)), model_store(k, v, model(map)))
    end
  end

  # First version of map generator
  # NOTE: there's a recursive call to map_1()
  def map_1 do
    map_gen = lazy do
      let {k, v, m} <- {key, val, map_1} do
        Map.put(m, k, v)
      end
    end

    oneof [Map.new, map_gen]
  end

  # NOTE: Make sure that the order is right!
  # {:call, Map, :put, [key, val, map_2]}] will *not* work!
  def map_2 do
    lazy do
      oneof [{:call, Map, :new, []},
             {:call, Map, :put, [map_2, key, val]}]
    end
  end

  def no_duplicates(elems) do
    left  = elems |> Enum.sort
    right = elems |> Enum.uniq |> Enum.sort
    # equal(:lists.sort(elems), :lists.usort(elems))
    equal(left, right)
  end

  def key do
    oneof [int, real, atom]
  end

  def val do
    key
  end

  def atom do
    elements [:a, :b, :c, true, false, :ok]
  end

  def model(map) do
    Map.to_list(map) 
  end

  def model_store(k, v, list) do
    [{k, v} | list]
  end

  def equal(x, y) do
    when_fail(IO.puts("FAILED ☛ #{inspect(x)} != #{inspect(y)}")) do
      x == y
    end
  end

end
