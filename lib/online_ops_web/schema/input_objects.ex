defmodule OnlineOpsWeb.Schema.InputObjects do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc "The required fields for creating a user"
  input_object :create_user_params do
    @desc "The user's email address"
    field :email, non_null(:string)

    @desc "The user's first name"
    field :first_name, non_null(:string)

    @desc "The user's last name"
    field :last_name, non_null(:string)
  end

  @desc "The required fields for creating a new session"
  input_object :create_session_params do
    @desc "The email address used to find the account"
    field :email, non_null(:string)
  end

  @desc "The required fields to validate a user's session"
  input_object :magic_token_params do
    @desc "The magic token associated with the session that is being authorized"
    field :token, non_null(:string)
  end

  @desc "The required fields to complete a setup step when creating a space"
  input_object :space_setup_params do
    @desc "The enum representing the current step being completed"
    field :step, non_null(:setup_step)

    @desc "The id that represents the Google Analyitcs Property or View to connect to the space"
    field :selection, :id
  end
end
