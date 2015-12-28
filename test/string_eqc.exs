defmodule StringEQC do
  use ExUnit.Case
  use EQC.ExUnit

  # NOTE: We will get deprecation warnings if `s1` is empty.
  property "starts with" do
    forall {s1, s2} <- {non_empty(list(char)), list(char)} do
      s1 = to_string(s1)
      s2 = to_string(s2)
      ensure String.starts_with?(s1 <> s2, s1) == true
    end
  end

  # NOTE: We will get deprecation warnings if `s2` is empty.
  property "ends with" do
    forall {s1, s2} <- {list(char), non_empty(list(char))} do
      s1 = to_string(s1)
      s2 = to_string(s2)
      ensure String.ends_with?(s1 <> s2, s2) == true
    end
  end

  # NOTE: We make use of Erlang's `:string.len` function to
  #       test against Elixir's implementation
  property "length" do
    forall s <- list(char) do
      str = to_string(s)
      equal(String.length(str), :string.len(s))
    end
  end

  # NOTE: We use collect here to point out that the distribution of the data is pretty crappy
  # property "splitting and joining a string with a delimiter yields back the original string" do
  #   forall {s, d} <- {string, delimiter} do
  #     collect string: s, delimiter: d, 
  #     in:
  #       equal(String.split(s, d) |> join(d), s)
  #   end
  # end

  # @tag numtests: 2000
  property "splitting and joining a string with a delimiter yields back the original string" do

    forall s <- string do
      forall d <- elements(s) do
        s = to_string(s)
        d = to_string([d])
        # NOTE: collect must only have the property in `in:`. in other words, only
        #       one line.
        # collect string: s, delimiter: d, in:
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
