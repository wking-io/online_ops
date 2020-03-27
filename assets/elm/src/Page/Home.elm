module Page.Home exposing (view)

import Html exposing (Html, div, h1, main_, text)
import Html.Attributes exposing (class, id, tabindex)



-- VIEW


view : { title : String, content : Html msg }
view =
    { title = "Home"
    , content =
        main_ [ id "content", class "container", tabindex -1 ]
            [ h1 [] [ text "Home" ]
            , div [ class "row" ]
                [ text "Home" ]
            ]
    }
