class Aphasia
  def initialize(http_client)
    @http_client = http_client
  end

  def repos(keyword)
    resp = @http_client.call("/legacy/repos/search/#{keyword}")
    create_repos_array(resp['repositories'])
  end

  def user_repos(username)
    resp = @http_client.call("/users/#{username}/repos")
    raise UserNotFound.new(username) if resp['message'].to_s == 'Not Found' if resp.is_a? Hash
    create_repos_array(resp)
  end

  private
  def create_repos_array(repositories)
    repositories_array = Array.new

    repositories.each do |repository_hash|
      repo = Repository.new.fill_from_hash(repository_hash)
      repositories_array.push(repo)
    end

    repositories_array
  end
end
