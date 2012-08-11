class CommitNotFound < Exception
  attr_reader :message

  def initialize(commit_name)
    @message = "The commit \"#{commit_name}\" doesn't exist."
  end
end
