class UserNotFound < Exception
  attr_reader :message

  def initialize message
    @message = message
  end
end
