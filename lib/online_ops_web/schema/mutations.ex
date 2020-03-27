defmodule OnlineOpsWeb.Schema.Mutations do
  @moduledoc false

  use Absinthe.Schema.Notation

  @desc "Interface for payloads containing validation data."
  interface :validatable do
    field :success, non_null(:boolean)
    field :errors, list_of(:error)
    resolve_type fn _, _ -> nil end
  end

  union :error do
    description "Error from mutation attempt."

    # TODO: Fix the structs to be schema for space_setup_step db
    types [:invalid_input]
    resolve_types fn
      %{code: :invalid_input}, _ -> :invalid_input
    end
  end

  object :invalid_input do
    field :field, non_null(:string)
    field :message, non_null(:string)
  end

  @desc "The response to user mutations."
  object :user_payload do
    @desc """
    A boolean indicating if the mutation was successful. If true, the errors
    list will be empty. Otherwise, errors may contain objects describing why
    the mutation failed.
    """
    field :success, non_null(:boolean)

    @desc "A list of validation errors."
    field :errors, list_of(:error)

    @desc """
    The mutated object. If the mutation was not successful,
    this field may be null.
    """
    field :user, :user

    interface :validatable
  end

  @desc "The response to creating a user session."
  object :create_session_payload do
    @desc """
    A boolean indicating if the mutation was successful. If true, the errors
    list will be empty. Otherwise, errors may contain objects describing why
    the mutation failed.
    """
    field :success, non_null(:boolean)

    @desc "A list of validation errors."
    field :errors, list_of(:error)

    interface :validatable
  end

  @desc "The response to mutations that fetch a user session."
  object :session_payload do
    @desc """
    A boolean indicating if the mutation was successful. If true, the errors
    list will be empty. Otherwise, errors may contain objects describing why
    the mutation failed.
    """
    field :success, non_null(:boolean)

    @desc "A list of validation errors."
    field :errors, list_of(:error)

    @desc """
    The mutated object. If the mutation was not successful,
    this field may be null.
    """
    field :session, :session

    interface :validatable
  end

  @desc "The response to space mutations."
  object :space_payload do
    @desc """
    A boolean indicating if the mutation was successful. If true, the errors
    list will be empty. Otherwise, errors may contain objects describing why
    the mutation failed.
    """
    field :success, non_null(:boolean)

    @desc "A list of validation errors."
    field :errors, list_of(:error)

    @desc """
    The mutated object. If the mutation was not successful,
    this field may be null.
    """
    field :space, :space

    interface :validatable
  end

  @desc "The response to completing a setup step."
  object :step_payload do
    @desc """
    A boolean indicating if the mutation was successful. If true, the errors
    list will be empty. Otherwise, errors may contain objects describing why
    the mutation failed.
    """
    field :success, non_null(:boolean)

    @desc "A list of validation errors."
    field :errors, list_of(:error)

    @desc """
    The mutated object. If the mutation was not successful,
    this field may be null.
    """
    field :step, :step_data

    interface :validatable
  end
end
