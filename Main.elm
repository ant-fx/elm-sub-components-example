module Main exposing (..)

import Html exposing (Html, button, div, text, h1)
import Html.App as Html
import Html.Events exposing (onClick)
import SomeComponent as SomeComponent


main =
    Html.program
        { init = init
        , view = view
        , update = update
        , subscriptions = subscriptions
        }



-- MODEL


type alias Model =
    { someComponent : SomeComponent.Model
    , count : Int
    }


model : Model
model =
    { someComponent = (SomeComponent.Model True)
    , count = 0
    }


init : ( Model, Cmd Msg )
init =
    ( model, Cmd.none )


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- UPDATE


type Msg
    = Increment
    | Decrement
    | SomeComponentMsg SomeComponent.Msg


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        Increment ->
            ( { model | count = model.count + 1 }, Cmd.none )

        Decrement ->
            ( { model | count = model.count - 1 }, Cmd.none )

        SomeComponentMsg message ->
            let
                ( newModel, cmd ) =
                    SomeComponent.update message model.someComponent
            in
                ( { model | someComponent = newModel }, Cmd.map SomeComponentMsg cmd )



-- VIEW


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "This is the main Component" ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , Html.map SomeComponentMsg (SomeComponent.view model.someComponent)
        ]
