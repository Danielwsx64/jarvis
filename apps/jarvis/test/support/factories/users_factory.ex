defmodule Jarvis.Support.Factories.UsersFactory do
  defmacro __using__(_opts \\ []) do
    quote do
      alias Jarvis.Accounts.Users.Schema

      def user_factory do
        %Schema{
          email: sequence(:email, &"user#{&1}@email.com"),
          image_url: sequence(:image_url, &"http://images.com/img/#{&1}.jpg")
        }
      end
    end
  end
end
