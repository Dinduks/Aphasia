require 'spec_helper'

describe 'Aphasia' do
  before do
    http_client = GitHubClientMock.new
    @aphasia = Aphasia.new(http_client)
  end

  describe 'find_repos' do
    it 'should return an array of repos' do
      repos = @aphasia.find_repos 'dinduks'
      repos.to_a.size.should == 2
      repos.each { |repo| repo.should be_a Repository }
    end

    it 'should return an empty array if the user has no repo' do
      repos = @aphasia.find_repos 'arepothatdoesntexist'
      repos.to_a.should be_empty
    end
  end

  describe 'find_user_repos' do
    it 'should return a specific user\'s repos if the user\'s specified' do
      repos = @aphasia.find_user_repos 'dinduks'
      repos.to_a.should_not be_empty
      repos.each { |repo| repo.should be_a Repository }
    end

    it 'should raise an exception if the user doesn\'t exist' do
      expect do
        repos = @aphasia.find_user_repos 'auserthatdoesntexist'
      end.to raise_error UserNotFound
    end
  end
end
