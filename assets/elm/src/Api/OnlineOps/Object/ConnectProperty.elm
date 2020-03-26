-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module OnlineOps.Object.ConnectProperty exposing (..)

import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode
import OnlineOps.InputObject
import OnlineOps.Interface
import OnlineOps.Object
import OnlineOps.Scalar
import OnlineOps.ScalarCodecs
import OnlineOps.Union


id : SelectionSet OnlineOps.ScalarCodecs.Id OnlineOps.Object.ConnectProperty
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (OnlineOps.ScalarCodecs.codecs |> OnlineOps.Scalar.unwrapCodecs |> .codecId |> .decoder)


options : SelectionSet decodesTo OnlineOps.Object.SetupOption -> SelectionSet (Maybe (List (Maybe decodesTo))) OnlineOps.Object.ConnectProperty
options object_ =
    Object.selectionForCompositeField "options" [] object_ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)
