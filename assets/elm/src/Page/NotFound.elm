module Page.NotFound exposing (view)

import Html exposing (Html, div, h1, main_, text)
import Html.Attributes exposing (class, id, tabindex)



-- VIEW


view : { title : String, content : Html msg }
view =
    { title = "Page Not Found"
    , content =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Not Found" ]
            , div [ class "row" ]
                [ text "not found" ]
            ]
    }
