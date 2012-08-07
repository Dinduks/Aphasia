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
      @repository.private.should be_false
      @repository.fork.should    be_false
      @repository.watchers.should       == 2
      @repository.size.should           == 5192
      @repository.pushed_at.should be_a  DateTime
      @repository.created_at.should be_a DateTime
    end
  end

  describe 'fill_object_from_hash' do
    before do
      http_client = GitHubClientMock.new
      hash = http_client.call '/users_dinduks_repos'
      @repository = RepositoryConverter.fill_object_from_hash hash[0]
    end

    it 'should return a Repository object' do
      @repository.should be_a Repository
    end

    it 'should correctly fill in the objects' do
      @repository.html_url.should == 'https://github.com/Dinduks/furry-octo-ninja'
      @repository.url.should      == 'https://api.github.com/repos/Dinduks/furry-octo-ninja'
      @repository.id.should       == 4118257

      @repository.owner.should be_a User
      @repository.owner.login.should       == 'Dinduks'
      @repository.owner.gravatar_id.should == 'd774db9cf2913d59b6e0e95662522b20'
      @repository.owner.url.should         == 'https://api.github.com/users/Dinduks'
      @repository.owner.avatar_url.should  == 'https://secure.gravatar.com/avatar/d774db9cf2913d59b6e0e95662522b20?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      @repository.owner.id.should          == 504977

      @repository.name.should        == 'furry-octo-ninja'
      @repository.full_name.should   == 'Dinduks/furry-octo-ninja'
      @repository.description.should == 'This is the application I use to share my code snippets'
      @repository.homepage.should    == 'http://snippets.dinduks.com'
      @repository.languages.should be_an Array
      @repository.languages.should include 'Ruby'

      @repository.private.should be_false
      @repository.fork.should    be_false
      @repository.forks.should    == 1
      @repository.watchers.should == 1
      @repository.size.should     == 172
      @repository.pushed_at.should  be_a DateTime
      @repository.created_at.should be_a DateTime
      @repository.updated_at.should be_a DateTime
    end
  end
end
