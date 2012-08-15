class AphasiaApp < Sinatra::Application
  before do
    http_client = GitHubClient.new 'api.github.com'
    @aphasia = Aphasia.new http_client
    response.headers['Access-Control-Allow-Origin'] = '*'
    response.headers['Access-Control-Allow-Headers'] = 'X-Requested-With'
  end

  get '/repos/:keyword' do
    repositories = @aphasia.find_repos(params['keyword'])
    repositories_array = RepositoryConverter.create_hash_from_an_array_of_objects repositories
    JSON.pretty_generate repositories_array
  end

  options '/repos/:keyword' do
  end

  get '/repo/:username/:repo/commits' do
    repository_full_name = params['username'] + '/' + params['repo']
    commits = @aphasia.find_repo_commits repository_full_name
    commits_array = CommitConverter.create_hash_from_an_array_of_objects commits
    JSON.pretty_generate commits_array
  end

  options '/repo/:username/:repo/commits' do
  end

  get '/user/:username/repos' do
    begin
      repositories = @aphasia.find_user_repos(params['username'])
    rescue UserNotFound
      raise Sinatra::NotFound
    end
    repositories_array = RepositoryConverter.create_hash_from_an_array_of_objects repositories
    JSON.pretty_generate repositories_array
  end

  options '/user/:username/repos' do
  end
end
