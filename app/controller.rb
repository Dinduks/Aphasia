class AphasiaApp < Sinatra::Application
  before do
    http_client = GitHubClient.new 'api.github.com'
    @aphasia = Aphasia.new http_client
  end

  get '/repos/:keyword' do
    repositories = @aphasia.find_repos(params['keyword'])
    repositories_array = RepositoryConverter.create_hash_from_an_array_of_objects(repositories)
    JSON.pretty_generate repositories_array
  end
end
