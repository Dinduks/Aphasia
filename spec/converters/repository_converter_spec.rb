require 'spec_helper'

describe 'RepositoryConverter' do
  describe 'fill_object_from_legacy_hash' do
    before do
      http_client = GitHubClientMock.new
      hash = http_client.call '/legacy_repos_search_dinduks'
      @repository = RepositoryConverter.fill_object_from_legacy_hash hash['repositories'][0]
    end

    it 'should return a Repository object' do
      @repository.should be_a Repository
    end

    it 'should correctly fill in the objects' do
      @repository.html_url.should       == 'https://github.com/Dinduks/dinduks.github.com'
      @repository.url.should            == 'https://api.github.com/repos/Dinduks/dinduks.github.com'
      @repository.owner.should be_a User
      @repository.owner.login.should    == 'Dinduks'
      @repository.name.should           == 'dinduks.github.com'
      @repository.full_name.should      == 'Dinduks/dinduks.github.com'
      @repository.description.should    == 'My blog\'s source code and posts'
      @repository.homepage.should       == 'http://www.dinduks.com/'
      @repository.languages.should be_an Array
      @repository.languages.should include 'JavaScript'
      @repository.private.should        == false
      @repository.fork.should           == false
      @repository.watchers.should       == 2
      @repository.size.should           == 5192
      @repository.pushed_at.should be_a  DateTime
      @repository.created_at.should be_a DateTime
    end
  end
end
