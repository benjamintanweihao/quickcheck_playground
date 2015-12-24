defmodule StringEQC do
  use ExUnit.Case
  use EQC.ExUnit

  # TODO: See the rest of the slides
  property "Reverse strings" do
    :eqc.fails(
      forall string <- utf8 do
        ensure String.reverse(String.reverse(string)) == string
      end
    )
  end

end
