import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (Html, button, div, text, h1)
import Html.App as App
import Html.Events exposing (onClick)
import Window
import Task
import Mouse

-- MODEL

(canvasWidth, canvasHeight) = (600,400)

type alias Model = 
  { windowSize: Window.Size 
  }

type Msg 
  = Increment 
  | Decrement 
  | NewWindowSize Window.Size
  | SizeUpdateFailure String
  | Coords Mouse.Position
  | Nothing

init : (Model, Cmd Msg)
init =
  let
    size = {width = 600, height = 800}
    model = {windowSize = size }
    windowSizeCmd = getWindowSize
    cmds = Cmd.batch [windowSizeCmd]
  in
    (model, cmds)

getWindowSize : Cmd Msg
getWindowSize = Task.perform SizeUpdateFailure NewWindowSize Window.size

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (model, Cmd.none)

-- SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [Window.resizes NewWindowSize]

-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    h1 [] [Html.text "hi"]
    , div [Html.on (Coords Mouse.position)] [
      toHtml <|
      container canvasWidth canvasHeight middle <|
      collage canvasWidth canvasHeight
        [ rect canvasWidth canvasHeight
          |> filled (rgb 0 0 0)
        ]
      ]
  ]


-- MAIN
main =
  App.program {
    init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
  }
