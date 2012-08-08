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
    repo.language    = hash['language']
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
    repo.language    = hash['language']
    repo.private     = hash['private'].to_s == 'false' ? false : true
    repo.fork        = hash['fork'].to_s    == 'false' ? false : true
    repo.forks       = hash['forks']
    repo.watchers    = hash['watchers']
    repo.size        = hash['size']
    repo.pushed_at   = DateTime.iso8601 hash['pushed_at']
    repo.created_at  = DateTime.iso8601 hash['created_at']
    repo.updated_at  = DateTime.iso8601 hash['updated_at']

    repo
  end

  def self.create_hash_from_object(repository)
    hash = Hash.new

    hash['owner'] = Hash.new
    hash['owner']['login'] = repository.owner.login
    hash['owner']['gravatar_id'] = repository.owner.gravatar_id
    hash['owner']['url'] = repository.owner.url
    hash['owner']['avatar_url'] = repository.owner.avatar_url
    hash['owner']['id'] = repository.owner.id

    hash['html_url']    = repository.html_url
    hash['url']         = repository.url
    hash['id']          = repository.id
    hash['name']        = repository.name
    hash['full_name']   = repository.full_name
    hash['description'] = repository.description
    hash['homepage']    = repository.homepage
    hash['language']    = repository.language
    hash['private']     = repository.private ? 'true' : 'false'
    hash['fork']        = repository.fork    ? 'true' : 'false'
    hash['forks']       = repository.forks
    hash['watchers']    = repository.watchers
    hash['size']        = repository.size
    hash['pushed_at']   = repository.pushed_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    hash['created_at']  = repository.created_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    begin
      hash['updated_at']  = repository.updated_at.strftime('%Y-%m-%dT%H:%M:%SZ')
    rescue
    end

    hash
  end

  def self.create_hash_from_an_array_of_objects(array)
    repositories = Array.new
    array.each do |repository|
      repositories.push(self.create_hash_from_object repository)
    end
    repositories
  end
end
