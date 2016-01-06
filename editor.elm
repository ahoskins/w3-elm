module Editor where

import Html exposing (..)
import Html.Attributes exposing (style, srcdoc, value, rows)
import Html.Events exposing (onClick, on, targetValue)
import List
import Json.Decode as Json

---------- MODEL -------------

type Action = 
    -- union type
      InputChange String 
    | RenderChange

type alias Model = 
    { input: String
    , render: String
    }

init : Model
init = 
    { input = "hello"
    , render = "hello"
    }

---------- UPDATE -------------

update : Action -> Model -> Model
update action model = 
    case action of
        InputChange str ->
            { model |
                input = str
            }
        RenderChange ->
            { model |
                render = model.input
            }

---------- VIEW ---------------

-- root view
view : Signal.Address Action -> Model -> Html
view address model = 
    div 
        [ ]
        [ makeTitle, makeButton address, mainView address model ]


makeInput : Signal.Address Action -> Model -> Html
makeInput address model = 
    textarea 
        -- function composition (InputChange takes a string, address takes Action)
        [ on "input" targetValue (Signal.message address << InputChange) 
        , value model.input
        , rows 20
        , style [ ("width", "100%")
                , ("font-family", "monospace")
                , ("font-size", "1.2em")
                , ("resize", "none")
                , ("border", "1px solid black")
                , ("height", "500px")
                ] 
        ] 
        [ ]


makeButton : Signal.Address Action -> Html
makeButton address = 
    div
        [ onClick address RenderChange
        , style [ ("background-color", "#d3d3d3")
                , ("border-radius", "3px")
                , ("display", "inline-block")
                , ("padding", "5px")
                , ("margin", "20px")
                , ("cursor", "pointer")
                , ("font-family", "monospace")
                , ("font-size", "1.2em")
                ]
        ]
        [ text "See Result "]


makeTitle : Html
makeTitle = 
    div 
        [ style [ ("font-size", "2.5em")
                , ("font-family", "monospace")
                , ("background-color", "#5cb5cd")
                , ("padding", "10px")
                ] 
        ]
        [ text "W3-Elm"]


mainView : Signal.Address Action -> Model -> Html
mainView address model = 
    let editor : Html
        editor = 
            div 
                [ style [ ("width", "50%")
                        , ("margin-right", "20px")
                        , ("font-family", "monospace")
                        , ("font-size", "1.2em")
                        ] 
                ] 
                [ text "Edit the code:"
                , makeInput address model
                ]
        render : Html
        render = 
            div 
                [ style [ ("width", "50%")
                        , ("font-family", "monospace")
                        , ("font-size", "1.2em")
                        ] 
                ]
                [ text "Result:"
                , iframe 
                    [ srcdoc model.render
                    , style [ ("width", "100%")
                            , ("border", "1px solid black")
                            , ("height", "500px")
                            ] 
                    ]
                    [ ] 
                ]
    in
        div 
            [ style [ ("display", "flex")
                    , ("margin", "0px 20px")
                    ] 
            ]
            [ editor, render ]

