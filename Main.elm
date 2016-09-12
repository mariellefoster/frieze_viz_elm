import Color exposing (..)
import Collage exposing (..)
import Element exposing (..)
import Html exposing (Html, button, div, text, h1, Attribute)
import Html.App as App
import Html.Events exposing (onClick, on)
import Window
import Task
import Mouse
import Json.Decode as Json exposing ((:=))

-- MODEL

(canvasWidth, canvasHeight) = (600,400)

type alias Model = 
  { windowSize: Window.Size,
    position: {x: Int, y: Int}
  }



type Msg
  = NewWindowSize Window.Size
  | SizeUpdateFailure String
  | Coords {x: Int, y: Int}
  | Nothing

init : (Model, Cmd Msg)
init =
  let
    size = {width = 600, height = 800}
    model = {windowSize = size, position = {x= 0, y = 0}}
    windowSizeCmd = getWindowSize
    cmds = Cmd.batch [windowSizeCmd]
  in
    (model, cmds)

getWindowSize : Cmd Msg
getWindowSize = Task.perform SizeUpdateFailure NewWindowSize Window.size

-- UPDATE

update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  (updateHelper msg model, Cmd.none)

updateHelper : Msg -> Model -> Model
updateHelper msg ({windowSize, position} as model) =
  case msg of
    Nothing -> model 
    NewWindowSize _ -> model
    SizeUpdateFailure _ -> model
    Coords pos -> {model | position = pos}


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.batch [Window.resizes NewWindowSize]

-- VIEW

view : Model -> Html Msg
view model =
  div [] [
    h1 [] [Html.text (toString (model.position.x, model.position.y))]
    , div [onMouseClick] [
      toHtml <|
      container canvasWidth canvasHeight middle <|
      collage canvasWidth canvasHeight
        [ rect canvasWidth canvasHeight
          |> filled (rgb 0 0 0)
        ]
      ]
  ]

onMouseClick : Attribute Msg
onMouseClick =
  on "mousedown" (Json.map Coords Mouse.position)


-- MAIN
main =
  App.program {
    init = init
    , update = update
    , view = view
    , subscriptions = subscriptions
  }

