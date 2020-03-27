-- Do not manually edit this file, it was auto-generated by dillonkearns/elm-graphql
-- https://github.com/dillonkearns/elm-graphql


module Api.OnlineOps.Object.StepPayload exposing (..)

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


{-| A list of failed validations. May be blank or null if mutation succeeded.
-}
messages : SelectionSet decodesTo Api.OnlineOps.Object.ValidationMessage -> SelectionSet (Maybe (List (Maybe decodesTo))) Api.OnlineOps.Object.StepPayload
messages object_ =
    Object.selectionForCompositeField "messages" [] object_ (identity >> Decode.nullable >> Decode.list >> Decode.nullable)


{-| The object created/updated/deleted by the mutation. May be null if mutation failed.
-}
result : SelectionSet decodesTo Api.OnlineOps.Union.StepData -> SelectionSet (Maybe decodesTo) Api.OnlineOps.Object.StepPayload
result object_ =
    Object.selectionForCompositeField "result" [] object_ (identity >> Decode.nullable)


{-| Indicates if the mutation completed successfully or not.
-}
successful : SelectionSet Bool Api.OnlineOps.Object.StepPayload
successful =
    Object.selectionForField "Bool" "successful" [] Decode.bool
