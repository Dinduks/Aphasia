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

  def self.create_hash_from_object(commit)
    hash = Hash.new

    hash['url'] = commit.url
    hash['sha'] = commit.sha
    hash['message'] = commit.message
    begin
      hash['date'] = commit.date.strftime('%Y-%m-%dT%H:%M:%SZ')
    rescue
    end

    hash['author'] = Hash.new
    hash['author']['login']       = commit.author.login
    hash['author']['avatar_url']  = commit.author.avatar_url
    hash['author']['url']         = commit.author.url
    hash['author']['gravatar_id'] = commit.author.gravatar_id
    hash['author']['id']          = commit.author.id

    hash['committer'] = Hash.new
    hash['committer']['login']       = commit.committer.login
    hash['committer']['avatar_url']  = commit.committer.avatar_url
    hash['committer']['url']         = commit.committer.url
    hash['committer']['gravatar_id'] = commit.committer.gravatar_id
    hash['committer']['id']          = commit.committer.id

    hash
  end

  def self.create_hash_from_an_array_of_objects(array)
    commits = Array.new
    array.each do |commit|
      commits.push(self.create_hash_from_object commit)
    end
    commits
  end
end
