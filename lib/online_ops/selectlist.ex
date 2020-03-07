defmodule OnlineOps.SelectList do
  @moduledoc """
  A `SelectList` is a nonempty list which always has exactly one element selected.

  It is an example of a list [zipper](https://en.wikipedia.org/wiki/Zipper_(data_structure)).
  """

  @type position :: :before_selected | :selected | :after_selected
  @type a :: any
  @type b :: any
  @type t(a) :: [[a], a, [a]]


  @doc """

  Return the elements before the selected element.

      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
      |> SelectList.before
      == [ 1, 2 ]

  """
  @spec get_before(t(any)) :: [any]
  def get_before([beforeSel, _, _]), do: beforeSel


  @doc """
  Return the elements after the selected element.

      import SelectList

      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.after

      == [ 3, 4, 5 ]

  """
  @spec get_after(t(any)) :: [any]
  def get_after([_, _, afterSel]), do: afterSel


  @doc """
  Return the selected element.

      import SelectList

      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.selected

      == 3
  """
  @spec get_selected(t(any)) :: any
  def get_selected([_, sel, _]), do: sel


  @doc """
  A `SelectList` containing exactly one element.

      import SelectList

      SelectList.singleton "foo"

      == SelectList.fromLists [] "foo" []

  """
  @spec singleton(any) :: t(any)
  def singleton(sel), do: [[], sel, []]


  @doc """
  Transform each element of the `SelectList`. The transform
  function receives a `Position` which is `Selected` if it was passed
  the SelectList's selected element, `BeforeSelected` if it was passed an element
  before the selected element, and `AfterSelected` otherwise.

      import SelectList exposing (Position(..))

      doubleOrNegate position num =
          if position == Selected then
              num * -1
          else
              num * 2


      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.mapBy doubleOrNegate

      == SelectList.fromLists [ 2, 4 ] -3 [ 8, 10, 12 ]

  """
  @spec mapBy(t(a), (position, a -> b)) :: t(b)
  def mapBy([beforeSel, sel, afterSel], transform) do
    [ (Enum.map(beforeSel, &(transform.(:before_selected, &1)))),
      transform.(:selected, sel),
      (Enum.map(afterSel, &(transform.(:after_selected, &1))))
    ]
  end


  @doc """
  Used with [`mapBy`](#mapBy).
  -}


  {-| Transform each element of the `SelectList`.

      import SelectList

      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.map (\num -> num * 2)

      == SelectList.fromLists [ 2, 4 ] 6 [ 8, 10, 12 ]

  """
  @spec map(t(a), (a -> b)) :: t(b)
  def map([beforeSel, sel, afterSel], transform) do
    [ (Enum.map(beforeSel, transform)),
      transform.(sel),
      (Enum.map(afterSel, transform))
    ]
  end

  @doc """
  Returns a `SelectList`.

      import SelectList

      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.selected

      == 3

  -}
  fromLists : List a -> a -> List a -> SelectList a
  fromLists =
      SelectList


  {-| Change the selected element to the first one which passes a
  predicate function. If no elements pass, the `SelectList` is unchanged.

      import SelectList

      isEven num =
          num % 2 == 0


      SelectList.fromLists [ 1, 2 ] 3 [ 4, 5, 6 ]
          |> SelectList.select isEven

      == SelectList.fromLists [ 1 ] 2 [ 3, 4, 5, 6 ]

  """
  @spec select(t(a), (a -> Bool)) :: t(a)
  def select([beforeSel, sel, afterSel] = original, isSelectable) do
    case selectHelp(isSelectable, beforeSel, sel, afterSel) do
      :nothing ->
        original

      {:just, new} ->
        new
    end
  end

  @spec selectHelp((a -> Bool), [a], a, [a]) :: :nothing | {:just, t}
  def selectHelp(isSelectable, beforeList, selectedElem, afterList) do
    case { beforeList, afterList } do
      { [], [] } ->
        :nothing

      { [], [first | rest] } ->
        cond do
          isSelectable.(selectedElem) ->
            {:just, [beforeList, selectedElem, afterList]}
          isSelectable.(first) ->
            {:just, [beforeList ++ [ selectedElem ], first, rest]}
          true ->
            case selectHelp(isSelectable, [], first, rest) do
              :nothing ->
                :nothing

              {:just, [newBefore, newSelected, newAfter]} ->
                {:just, [[selectedElem | newBefore], newSelected, newAfter]}
            end
        end

      { [first | rest], _ } ->
        if isSelectable.(first) do
          {:just, [[], first, [[rest ++ selectedElem] | afterList]] }
        else
          case selectHelp(isSelectable, rest, selectedElem, afterList) do
            :nothing ->
              :nothing

            {:just, [newBefore, newSelected, newAfter]} ->
              {:just, [[first | newBefore], newSelected, newAfter]}
          end
        end
    end
  end


  @doc """
  Add elements to the end of a `SelectList`.

      import SelectList

      SelectList.fromLists [ 1, 2 ] 3 [ 4 ]
          |> SelectList.append [ 5, 6 ]

      == SelectList.fromLists [ 1 ] 2 [ 3, 4, 5, 6 ]

  """
  @spec append(t(a), [a]) :: t(a)
  def append([beforeSel, sel, afterSel], list), do: [beforeSel, sel, (afterSel ++ list)]


  @doc """
  Add elements to the beginning of a `SelectList`.

      import SelectList

      SelectList.fromLists [ 3 ] 4 [ 5, 6 ]
          |> SelectList.prepend [ 1, 2 ]

      == SelectList.fromLists [ 1, 2, 3 ] 4 [ 5, 6 ]

  """
  @spec prepend(t(a), [a]) :: t(a)
  def prepend([beforeSel, sel, afterSel], list), do: [(list ++ beforeSel), sel, afterSel]


  @doc """
  Return a `List` containing the elements in a `SelectList`.

      import SelectList

      SelectList.fromLists [ 1, 2, 3 ] 4 [ 5, 6 ]
          |> SelectList.toList

      == [ 1, 2, 3, 4, 5, 6 ]

  """
  @spec toList(t(a)) :: [a]
  def toList([beforeSel, sel, afterSel]), do: beforeSel ++ [sel | afterSel]
end
