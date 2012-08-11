require 'spec_helper'

describe 'CommitConverter' do
  describe 'fill_object_from_hash' do
    before do
      http_client = GitHubClientMock.new
      hash = http_client.call '/repos_playframework_Play20_commits'
      @commit = CommitConverter.fill_object_from_hash hash[0], 'playframework/Play20'
    end

    it 'should return a Commit object' do
      @commit.should be_a Commit
    end

    it 'should correctly fill in the objects' do
      @commit.sha.should == '2294e23acb2278f09fcd2de66a61ac03d786926d'
      @commit.url.should == "https://github.com/playframework/Play20/commits/#{@commit.sha}"
      @commit.message.should == 'now onRequestCompletion is called on response sent or socket closing'

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
  end
end
