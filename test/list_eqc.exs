defmodule ListEQC do
  use ExUnit.Case
  use EQC.ExUnit

  @tag numtests: 100
  property "Deleting from a list" do
    forall list <- ulist(int) do
      implies list != [] do
        forall item <- elements(list) do
          ensure not item in List.delete(list, item) == true
        end
      end
    end
  end

  property "Misconception of deleting from a list" do
    :eqc.fails(
      forall list <- list(int) do
        implies list != [] do
          forall item <- elements(list) do
            ensure not item in List.delete(list, item) == true
          end
        end
      end
    )
  end

  property "Deleting an element not in a list leaves the list unchanged" do
    forall list <- list(int) do
      forall item <- int do
        implies not item in list do
            ensure list == List.delete(list, item)
        end
      end
    end
  end

  # Custom generator to generate unique lists
  def ulist(item) do
    let l <- list(item) do
      l |> Enum.sort |> Enum.uniq
    end
  end

end
