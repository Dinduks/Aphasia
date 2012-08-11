class CommitConverter
  def self.fill_object_from_hash(hash, repository_full_name)
    commit = Commit.new

    commit.sha = hash['sha']
    commit.url = "https://github.com/#{repository_full_name}/commits/#{hash['sha']}"
    commit.message = hash['commit']['message']
    commit.date    = DateTime.iso8601 hash['commit']['committer']['date']

    author = User.new
    author.login       = hash['author']['login']
    author.avatar_url  = hash['author']['avatar_url']
    author.gravatar_id = hash['author']['gravatar_id']
    author.id          = hash['author']['id']
    author.url         = "https://github.com/#{author.login}"
    commit.author      = author

    committer = User.new
    committer.login       = hash['committer']['login']
    committer.avatar_url  = hash['committer']['avatar_url']
    committer.gravatar_id = hash['committer']['gravatar_id']
    committer.id          = hash['committer']['id']
    committer.url         = "https://github.com/#{committer.login}"
    commit.committer      = committer

    commit
  end
end
