-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.OnlineOps.Object.ConnectAccount exposing (..)

import Api.OnlineOps.InputObject
import Api.OnlineOps.Interface
import Api.OnlineOps.Object
import Api.OnlineOps.Scalar
import Api.OnlineOps.ScalarCodecs
import Api.OnlineOps.Union
import Graphql.Internal.Builder.Argument as Argument exposing (Argument)
import Graphql.Internal.Builder.Object as Object
import Graphql.Internal.Encode as Encode exposing (Value)
import Graphql.Operation exposing (RootMutation, RootQuery, RootSubscription)
import Graphql.OptionalArgument exposing (OptionalArgument(..))
import Graphql.SelectionSet exposing (SelectionSet)
import Json.Decode as Decode


id : SelectionSet Api.OnlineOps.ScalarCodecs.Id Api.OnlineOps.Object.ConnectAccount
id =
    Object.selectionForField "ScalarCodecs.Id" "id" [] (Api.OnlineOps.ScalarCodecs.codecs |> Api.OnlineOps.Scalar.unwrapCodecs |> .codecId |> .decoder)


options : SelectionSet decodesTo Api.OnlineOps.Object.SetupOption -> SelectionSet (Maybe (List (Maybe decodesTo))) Api.OnlineOps.Object.ConnectAccount
options object_ =
    Object.selectionForCompositeField "options" [] object_ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)