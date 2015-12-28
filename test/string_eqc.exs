defmodule StringEQC do
  use ExUnit.Case
  use EQC.ExUnit

  # NOTE: We use collect here to point out that the distribution of the data is pretty crappy
  # property "splitting and joining a string with a delimiter yields back the original string" do
  #   forall {s, d} <- {string, delimiter} do
  #     collect string: s, delimiter: d, 
  #     in:
  #       equal(String.split(s, d) |> join(d), s)
  #   end
  # end

  @tag numtests: 2000
  property "splitting and joining a string with a delimiter yields back the original string" do

    forall s <- string do
      forall d <- elements(s) do
        s = to_string(s)
        d = to_string([d])
        # NOTE: collect must only have the property in `in:`. in other words, only
        #       one line.
        collect string: s, delimiter: d, in:
          equal(String.split(s, d) |> join(d), s)
      end
    end

  end

  def string do
    # NOTE: We can use `non_empty` instead of `implies s != []`
    #         forall s <- non_empty(list(char)) do
    #           implies s != [] do
    #             ...
    #           end
    #         end
    non_empty(list(alpha))
  end

  def alpha do
    # oneof(:lists.seq(?a, ?z) ++ :lists.seq(?A, ?Z))
    oneof(:lists.seq(?a, ?z))
  end

  def join(parts, delimiter) do
    parts |> Enum.intersperse([delimiter]) |> Enum.join
  end

  def equal(x, y) do
    when_fail(IO.puts("FAILED ☛ #{inspect(x)} != #{inspect(y)}")) do
      x == y
    end
  end

end
