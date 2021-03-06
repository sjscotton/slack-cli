require_relative "test_helper"
require "pry"

describe "user" do
  describe "initialize" do
    before do
      @new_user = SlackBot::User.new(real_name: "Sarah", name: "Riyo", id: "USRJFDJFKD")
    end

    it "creates an instance of user" do
      expect(@new_user).must_be_kind_of SlackBot::User
    end
  end
  describe "self.list" do
    it "Returns an array of hashes" do
      VCR.use_cassette("self.list") do
        user_list = SlackBot::User.list

        expect(user_list).must_be_kind_of Array
        expect(user_list.first).must_be_kind_of SlackBot::User
        expect(user_list.last).must_be_kind_of SlackBot::User
      end
    end
    it "Returns users real_name, id and name" do
      VCR.use_cassette("self.list") do
        user_list = SlackBot::User.list

        expect(user_list.first.real_name).must_equal "Slackbot"
        expect(user_list.first.id).must_equal "USLACKBOT"
        expect(user_list.first.name).must_equal "slackbot"
      end
    end

  end
  describe "send message" do
    before do
      VCR.use_cassette("send message") do
        @user_list = SlackBot::User.list
      end
    end
      
     
    it "returns true if given a valid message" do
      VCR.use_cassette("send working message") do
        message = "Hello!"
        expect(@user_list.first.send_message(message)).must_equal true
      end
    end

    it "returns a slackapierror when given an empty string" do
      VCR.use_cassette("send message with empty string") do
        message = ""
        expect {
        @user_list.first.send_message(message)
        }.must_raise SlackBot::SlackApiError
      end
    end
  end
end
