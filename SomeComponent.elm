module SomeComponent exposing (..)

import Html exposing (Html, button, div, text, h1)
import Html.Events exposing (onClick)


type Msg
    = Open
    | Close


type alias Model =
    { isOpen : Bool
    }


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Open ->
            ( { model | isOpen = True }, Cmd.none )

        Close ->
            ( { model | isOpen = False }, Cmd.none )


view : Model -> Html Msg
view model =
    if model.isOpen then
        div []
            [ h1 [] [ text "This is SomeComponent (Open)" ]
            , button [ onClick Open ] [ text "Open" ]
            , button [ onClick Close ] [ text "Close" ]
            ]
    else
        div []
            [ h1 [] [ text "This is SomeComponent (Closed)" ]
            , button [ onClick Open ] [ text "Open" ]
            , button [ onClick Close ] [ text "Close" ]
            ]
