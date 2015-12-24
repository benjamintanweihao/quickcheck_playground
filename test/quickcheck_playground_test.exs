defmodule QuickcheckPlaygroundTest do
  use ExUnit.Case
  use ExCheck

  # delete(list, item)
  property :delete do
    for_all {list, item} in {list(int), int} do
      implies no_duplicates?(list) do
        not item in List.delete(list, item)
      end
    end
  end

  def no_duplicates?(list) do
    Enum.sort(list) == Enum.sort(Enum.uniq(list))
  end

end
