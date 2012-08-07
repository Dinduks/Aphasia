class RepositoryConverter
  def self.fill_object_from_legacy_hash(hash)
    repo = Repository.new

    repo.html_url    = hash['url']
    repo.url         = "https://api.github.com/repos/#{hash['owner']}/#{hash['name']}"
    owner = User.new
    owner.login      = hash['owner']
    repo.owner       = owner
    repo.name        = hash['name']
    repo.full_name   = hash['owner'] + '/' + hash['name']
    repo.description = hash['description']
    repo.homepage    = hash['homepage']
    repo.languages   = Array.new.push hash['language']
    repo.private     = hash['private'].to_s == 'false' ? false : true
    repo.fork        = hash['fork'].to_s == 'false' ? false : true
    repo.watchers    = hash['watchers']
    repo.size        = hash['size']
    repo.pushed_at   = DateTime.iso8601 hash['pushed_at']
    repo.created_at  = DateTime.iso8601 hash['created_at']

    repo
  end

  def self.fill_object_from_hash(hash)
    repo = Repository.new

    repo.html_url = hash['html_url']
    repo.url    = hash['url']
    repo.id    = hash['id']

    owner             = User.new
    owner.login       = hash['owner']['login']
    owner.gravatar_id = hash['owner']['gravatar_id']
    owner.url         = hash['owner']['url']
    owner.avatar_url  = hash['owner']['avatar_url']
    owner.id          = hash['owner']['id']
    repo.owner        = owner

    repo.name        = hash['name']
    repo.full_name   = hash['full_name']
    repo.description = hash['description']
    repo.homepage    = hash['homepage']
    repo.languages   = Array.new.push hash['language']
    repo.private     = hash['private'].to_s == 'false' ? false : true
    repo.fork        = hash['fork'].to_s    == 'false' ? false : true
    repo.forks       = hash['forks']
    repo.watchers    = hash['watchers']
    repo.size        = hash['size']
    repo.pushed_at   = DateTime.iso8601 hash['pushed_at']
    repo.created_at  = DateTime.iso8601 hash['created_at']
    repo.updated_at  = DateTime.iso8601 hash['created_at']

    repo
  end
end
