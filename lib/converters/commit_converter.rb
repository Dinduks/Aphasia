class CommitConverter
  def self.fill_object_from_hash(hash, repository_full_name)
    commit = Commit.new

    commit.sha = hash['sha']
    commit.url = "https://github.com/#{repository_full_name}/commits/#{hash['sha']}"
    commit.message = hash['commit']['message']
    commit.date    = DateTime.iso8601 hash['commit']['committer']['date']

    commit.author = User.new
    if hash['author']
      commit.author.login       = hash['author']['login']
      commit.author.avatar_url  = hash['author']['avatar_url']
      commit.author.gravatar_id = hash['author']['gravatar_id']
      commit.author.id          = hash['author']['id']
      commit.author.url         = "https://github.com/#{commit.author.login}"
    end

    commit.author.name        = hash['commit']['author']['name']
    commit.author.email       = hash['commit']['author']['email']

    commit.committer = User.new
    if hash['committer']
      commit.committer.login       = hash['committer']['login']
      commit.committer.avatar_url  = hash['committer']['avatar_url']
      commit.committer.gravatar_id = hash['committer']['gravatar_id']
      commit.committer.id          = hash['committer']['id']
      commit.committer.url         = "https://github.com/#{commit.committer.login}"
    end

    commit.committer.name        = hash['commit']['committer']['name']
    commit.committer.email       = hash['commit']['committer']['email']

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
    hash['author']['name']        = commit.author.name
    hash['author']['email']       = commit.author.email

    hash['committer'] = Hash.new
    hash['committer']['login']       = commit.committer.login
    hash['committer']['avatar_url']  = commit.committer.avatar_url
    hash['committer']['url']         = commit.committer.url
    hash['committer']['gravatar_id'] = commit.committer.gravatar_id
    hash['committer']['id']          = commit.committer.id
    hash['committer']['name']        = commit.committer.name
    hash['committer']['email']       = commit.committer.email

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
