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

  describe 'find_repo_commits' do
    it 'should return an array of commits'do
      commits = @aphasia.find_repo_commits 'playframework/Play20'
      commits.should be_an Array
      commits.to_a.should_not be_empty
      commits.each { |commit| commit.should be_a Commit }
    end

    it 'should return an empty array if no commits were found' do
      commits = @aphasia.find_repo_commits 'emptyrepo'
      commits.should be_an Array
      commits.to_a.should be_empty
    end

    it 'should raise an exception if the repo doesn\'t exist' do
      expect do
        commits = @aphasia.find_repo_commits 'arepothatdoesntexist'
      end.to raise_error CommitNotFound
    end
  end
end
