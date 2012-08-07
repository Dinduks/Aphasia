class Aphasia
  def initialize(http_client)
    @http_client = http_client
  end

  def find_repos(keyword)
    resp = @http_client.call("/legacy/repos/search/#{keyword}")

    repos = create_repos_array(resp['repositories']) do |hash|
      RepositoryConverter.fill_object_from_legacy_hash hash
    end
  end

  def find_user_repo(username)
    resp = @http_client.call("/users/#{username}/repos")
    raise UserNotFound.new(username) if resp['message'].to_s == 'Not Found' if resp.is_a? Hash

    create_repos_array(resp) do |hash|
      Repository.new.fill_from_hash! hash
    end
  end

  private
  def create_repos_array(repositories)
    repositories_array = Array.new
    repositories.each do |repository_hash|
      repo = yield repository_hash
      repositories_array.push(repo)
    end
    repositories_array
  end
end
