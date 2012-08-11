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

  def find_user_repos(username)
    resp = @http_client.call("/users/#{username}/repos")
    raise UserNotFound.new(username) if resp['message'].to_s == 'Not Found' if resp.is_a? Hash

    create_repos_array(resp) do |hash|
      RepositoryConverter.fill_object_from_hash hash
    end
  end

  def find_repo_commits(repository_full_name)
    resp = @http_client.call("/repos/#{repository_full_name}/commits")

    if resp.is_a? Hash
      message = resp['message'].to_s
      if message == 'Not Found'
        raise CommitNotFound.new(repository_full_name)
      elsif message == 'Git Repository is empty.'
        return []
      end
    end

    create_commits_array(resp) do |hash|
      CommitConverter.fill_object_from_hash hash, repository_full_name
    end
  end

  private
  def create_commits_array(commits)
    commits_array = Array.new
    commits.each do |commit_hash|
      commit = yield commit_hash
      commits_array.push(commit)
    end
    commits_array
  end

  def create_repos_array(repositories)
    repositories_array = Array.new
    repositories.each do |repository_hash|
      repo = yield repository_hash
      repositories_array.push(repo)
    end
    repositories_array
  end
end
