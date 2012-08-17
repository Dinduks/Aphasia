require 'spec_helper'

describe 'CommitConverter' do
  describe 'fill_object_from_hash' do
    before do
      http_client = GitHubClientMock.new
      hash = http_client.call '/repos_playframework_Play20_commits'
      @commit = CommitConverter.fill_object_from_hash hash[0], 'playframework/Play20'
      @lacking_info_commit = CommitConverter.fill_object_from_hash hash[1], 'playframework/Play20'
    end

    it 'should return a Commit object' do
      @commit.should be_a Commit
    end

    it 'should correctly fill in the objects' do
      @commit.sha.should == '2294e23acb2278f09fcd2de66a61ac03d786926d'
      @commit.url.should == "https://github.com/playframework/Play20/commits/#{@commit.sha}"
      @commit.message.should == 'now onRequestCompletion is called on response sent or socket closing'
      @commit.date.should be_a Date
      @commit.date.day.should    == 10
      @commit.date.month.should  == 8
      @commit.date.year.should   == 2012
      @commit.date.hour.should   == 14
      @commit.date.minute.should == 9
      @commit.date.sec.should    == 54

      @commit.author.should be_a User
      @commit.author.login.should       == 'sadache'
      @commit.author.avatar_url.should  == 'https://secure.gravatar.com/avatar/d349588ba91256515f7e2aa315e8cfae?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      @commit.author.url.should         == "https://github.com/#{@commit.author.login}"
      @commit.author.gravatar_id.should == 'd349588ba91256515f7e2aa315e8cfae'
      @commit.author.id.should          == 60507

      @commit.committer.should be_a User
      @commit.committer.login.should       == 'sadache'
      @commit.committer.avatar_url.should  == 'https://secure.gravatar.com/avatar/d349588ba91256515f7e2aa315e8cfae?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      @commit.committer.url.should         == "https://github.com/#{@commit.committer.login}"
      @commit.committer.gravatar_id.should == 'd349588ba91256515f7e2aa315e8cfae'
      @commit.committer.id.should          == 60507
    end

    it 'should correctly fill objects that lack some info (such as author info)' do
      @lacking_info_commit.author.should be_a User
      @lacking_info_commit.author.name.should  == 'shu'
      @lacking_info_commit.author.email.should == 'shu@navi.rfrn.org'

      @lacking_info_commit.committer.should be_a User
      @lacking_info_commit.committer.name.should  == 'shu'
      @lacking_info_commit.committer.email.should == 'shu@navi.rfrn.org'
    end
  end

  describe 'create_hash_from_object' do
    it 'should return a correct json string' do
      sample_object_hash = JSON.parse(File.open(File.dirname(__FILE__) + '/../resources/sample_commit.json').read)
      commit = CommitConverter.fill_object_from_hash sample_object_hash, 'playframework/Play20'

      hash = CommitConverter.create_hash_from_object commit

      hash['url'].should     == "https://github.com/playframework/Play20/commits/#{commit.sha}"
      hash['sha'].should     == '2294e23acb2278f09fcd2de66a61ac03d786926d'
      hash['message'].should == 'now onRequestCompletion is called on response sent or socket closing'
      hash['date'].should    == '2012-08-10T14:09:54Z'

      hash['author']['login'].should       == 'sadache'
      hash['author']['avatar_url'].should  == 'https://secure.gravatar.com/avatar/d349588ba91256515f7e2aa315e8cfae?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      hash['author']['url'].should         == "https://github.com/#{commit.author.login}"
      hash['author']['gravatar_id'].should == 'd349588ba91256515f7e2aa315e8cfae'
      hash['author']['id'].should          == 60507
      hash['author']['name'].should        == 'Sadek Drobi'
      hash['author']['email'].should       == 'github@sadekdrobi.com'

      hash['committer']['login'].should       == 'sadache'
      hash['committer']['avatar_url'].should  == 'https://secure.gravatar.com/avatar/d349588ba91256515f7e2aa315e8cfae?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-140.png'
      hash['committer']['url'].should         == "https://github.com/#{commit.committer.login}"
      hash['committer']['gravatar_id'].should == 'd349588ba91256515f7e2aa315e8cfae'
      hash['committer']['id'].should          == 60507
      hash['committer']['name'].should        == 'Sadek Drobi'
      hash['committer']['email'].should       == 'github@sadekdrobi.com'
    end
  end

  describe 'create_hash_from_an_array_of_objects' do
    it 'should return an array of commits' do
      sample_object_hash = JSON.parse(File.open(File.dirname(__FILE__) + '/../resources/sample_commit.json').read)
      commit = CommitConverter.fill_object_from_hash sample_object_hash, 'playframework/Play20'

      commits = [commit, commit]
      commits_array = CommitConverter.create_hash_from_an_array_of_objects commits
      commits_array.should be_an Array
    end
  end
end
