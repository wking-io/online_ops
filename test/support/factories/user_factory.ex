defmodule OnlineOps.UserFactory do
  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %OnlineOps.Schemas.User{
          first_name: "Jane",
          last_name: "Smith",
          email: sequence(:email, &"email-#{&1}@example.com"),
        }
      end
    end
  end
end