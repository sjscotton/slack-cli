require "pry"

module SlackBot
  class User < Recipient
    PATH_URL = "users.list?"
    attr_reader :real_name, :name, :id

    def initialize(real_name:, name:, id:)
      @real_name = real_name
      @name = name
      @id = id
    end

    def self.list
      response = get(PATH_URL)
      check_response_code(response)

      users_array = response["members"].map do |user|
        SlackBot::User.new(real_name: user["real_name"], name: user["name"], id: user["id"])
      end

      return users_array
    end

    def details
      user_details = {
        real_name: @real_name,
        name: @name,
        id: @id,
      }
      return user_details
    end
  end
end
