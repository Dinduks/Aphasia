require 'spec_helper'

describe 'RepositoryConverter' do
  describe 'fill_object_from_legacy_hash' do
    before do
      http_client = GitHubClientMock.new
      hash = http_client.call '/legacy/repos/search/dinduks'
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
      @repository.language.should      == 'JavaScript'
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
      @repository.language.should    == 'Ruby'

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

  describe 'create_json_from_object' do
    it 'should return a correct json string' do
      sample_object_hash = JSON.parse(File.open(File.dirname(__FILE__) + '/../resources/sample_repository.json').read)
      repository = RepositoryConverter.fill_object_from_hash sample_object_hash

      hash = RepositoryConverter.create_hash_from_object repository

      hash['owner']['login']       == 'Dinduks'
      hash['owner']['gravatar_id'] == 'd774db9cf2913d59b6e0e95662522b20'
      hash['owner']['url']         == 'https://api.github.com/users/Dinduks'
      hash['owner']['avatar_url']  == 'https://secure.gravatar.com/avatar/d774db9cf2913d59b6e0e95662522b20?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      hash['owner']['id']          == 504977

      hash['html_url'].should    == 'https://github.com/Dinduks/furry-octo-ninja'
      hash['url'].should         == 'https://api.github.com/repos/Dinduks/furry-octo-ninja'
      hash['id'].should          == 4118257
      hash['name'].should        == 'furry-octo-ninja'
      hash['full_name'].should   == 'Dinduks/furry-octo-ninja'
      hash['description'].should == 'This is the application I use to share my code snippets'
      hash['homepage'].should    == 'http://snippets.dinduks.com'
      hash['language'].should    == 'Ruby'
      hash['private'].should     == 'false'
      hash['fork'].should        == 'false'
      hash['forks'].should       == 1
      hash['watchers'].should    == 1
      hash['size'].should        == 172
      hash['pushed_at'].should   == '2012-07-31T21:03:52Z'
      hash['created_at'].should  == '2012-04-23T21:39:19Z'
      hash['updated_at'].should  == '2012-07-31T21:03:53Z'
    end
  end

  describe 'create_hash_from_an_array_of_objects' do
    it 'should return an array of hashes' do
      sample_object_hash = JSON.parse(File.open(File.dirname(__FILE__) + '/../resources/sample_repository.json').read)
      repository = RepositoryConverter.fill_object_from_hash sample_object_hash

      array = RepositoryConverter.create_hash_from_an_array_of_objects Array.new.push(repository, repository)
      array.should be_an Array
      array.size.should == 2
      array.each { |repository| repository.should be_a Hash }
    end
  end
end
