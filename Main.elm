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
{-

   Elm uses a single point of knowledge, that means that this is the only real user
   data in the entire application, so we have to store any sub-components's data
   in this Model.

   So as well as our own model we also define an instance of SomeComponent.Model
   that we use to store any data required by SomeComponent. We will use it to
   generate SomeComponent's view later on

-}


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



-- VIEW
{-
   Here view makes a call to SomeComponent.view passing in the instance of SomeComponent.Model
   from it's own model defined above.

    Problem: Main.view returns Html Msg but SomeComponent.view returns Html SomeComponent.Msg
    which are not compatible types.

    So we use the Html.map function to 'map' SomeComponent.Msg
    to a message defined in Main.Msg, in this case we added a new message called SomeComponentMsg

    Now, when any messages are generated in SomeComponent they are sent to Main.update as a
    SomeComponentMsg and the SomeComponent.Msg is given as the 'payload' (the param to the message)
-}


view : Model -> Html Msg
view model =
    div []
        [ h1 [] [ text "This is the main Component" ]
        , button [ onClick Decrement ] [ text "-" ]
        , div [] [ text (toString model.count) ]
        , button [ onClick Increment ] [ text "+" ]
        , Html.map SomeComponentMsg (SomeComponent.view model.someComponent)
        ]



{-

   As well as handling its own messages, Main.update now handles messages generated
   from SomeComponent via the SomeComponentMsg message.

   When one of these messages is received we also get the real SomeComponent.Msg
   as the argument (payload). So we call SomeComponent.update passing in the
   model from Main.Model and the real message

   That returns a new instance of SomeComponent.Model that we update in our instance
   of Main.Model and a SomeComponent.Cmd

   Again, SomeComponent.Cmd is not compatible with Main.Cmd which Main.update needs to
   return, so we call Cmd.map to 'map' the SomeComponent.Msg to Main.Msg just like we
   did with Html.map above

-}


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
