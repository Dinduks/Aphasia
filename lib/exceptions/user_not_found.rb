class UserNotFound < Exception
  attr_reader :message

  def initialize(username)
    @message = "The user \"#{username}\" doesn't exist."
  end
end
