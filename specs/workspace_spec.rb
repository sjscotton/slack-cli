require_relative "test_helper"

describe "Workspace" do
  describe "Initialize" do
    before do
      VCR.use_cassette("initialize") do
        @workspace = SlackBot::Workspace.new
      end
    end
    it "Creates a workspace object" do
      expect(@workspace).must_be_kind_of SlackBot::Workspace
    end

    it "Initializes with selected equal to nil" do
      assert_nil @workspace.selected
    end
    it "Creates a list of users" do
      expect(@workspace.users).must_be_kind_of Array
      expect(@workspace.users.first).must_be_kind_of SlackBot::User
      expect(@workspace.users.first.real_name).must_equal "Slackbot"
      expect(@workspace.users.first.name).must_equal "slackbot"
      expect(@workspace.users.first.id).must_equal "USLACKBOT"
    end
  end
  describe "list" do
    before do
      VCR.use_cassette("list") do
        @workspace = SlackBot::Workspace.new
      end
    end
    it "returns an array of hashes for list_users" do
      users = @workspace.list_users
      expect(users).must_be_kind_of Array
      expect(users.first).must_be_kind_of Hash
      expect(users.first[:name]).must_equal "slackbot"
      expect(users.first[:id]).must_equal "USLACKBOT"
      expect(users.first[:real_name]).must_equal "Slackbot"
    end
    it "returns an array of hashes for list_channel" do
      channels = @workspace.list_channels
      expect(channels).must_be_kind_of Array
      expect(channels.first).must_be_kind_of Hash
      expect(channels.first[:name]).must_equal "slack-api-project"
      expect(channels.first[:id]).must_equal "CH2P99HT5"
      expect(channels.first[:num_members]).must_equal 2
    end
  end
  describe "select" do
    before do
      VCR.use_cassette("select") do
        @workspace = SlackBot::Workspace.new
      end
    end
    it "returns nil if no user found with id given" do
      selected = @workspace.select_user("USLACKNOT")
      assert_nil selected
    end
    it "returns nil if no user found with name given" do
      selected = @workspace.select_user("Devin")
      assert_nil selected
    end
    it "returns a User object if given a valid user id" do
      selected = @workspace.select_user("USLACKBOT")
      expect(selected).must_be_kind_of SlackBot::User
      expect(selected.name).must_equal "slackbot"
    end
    it "returns a User object if given a valid user name" do
      selected = @workspace.select_user("slackbot")
      expect(selected).must_be_kind_of SlackBot::User
      expect(selected.id).must_equal "USLACKBOT"
    end

    it "returns nil if no channel found with id given" do
      selected = @workspace.select_channel("CH2P99HT6")
      assert_nil selected
    end
    it "returns nil if no channel found with name given" do
      selected = @workspace.select_channel("slack-bpi-project")
      assert_nil selected
    end
    it "returns a Channel object if given a valid user id" do
      selected = @workspace.select_channel("CH2SL5C3C")
      expect(selected).must_be_kind_of SlackBot::Channel
      expect(selected.name).must_equal "everyone"
    end
    it "returns a Channel object if given a valid name" do
      selected = @workspace.select_channel("random")
      expect(selected).must_be_kind_of SlackBot::Channel
      expect(selected.id).must_equal "CH2SL5DEW"
    end
  end
  describe "send message" do
    before do
      VCR.use_cassette("select") do
        @workspace = SlackBot::Workspace.new
      end
    end

    it "returns false if no user or channel is selected" do
      expect(@workspace.send_message("Hi")).must_equal false
    end

    it "returns a slackapierror when given an empty message" do
      VCR.use_cassette("send message with empty string") do
        message = ""
        expect {
          @workspace.users.first.send_message(message)
        }.must_raise SlackBot::SlackApiError
      end
    end

    it "returns true if given a valid message and valid user/channel selected" do
      VCR.use_cassette("send message with empty string") do
        message = "Hello!"
        @workspace.select_user(@workspace.users.first.id)
        expect(@workspace.send_message(message)).must_equal true
      end
    end
  end
end
