class GitHubClientMock
  def call(path)
    case path
    when '/users/dinduks/repos'
      resp = File.open(File.dirname(__FILE__) + '/../resources/users_dinduks_repos.json').read
    when '/users/auserthatdoesntexist/repos'
      resp = File.open(File.dirname(__FILE__) + '/../resources/users_auserthatdoesntexist_repos.json').read
    when '/legacy/repos/search/dinduks'
      resp = File.open(File.dirname(__FILE__) + '/../resources/legacy_repos_search_dinduks.json').read
    when '/legacy/repos/search/arepothatdoesntexist'
      resp = File.open(File.dirname(__FILE__) + '/../resources/legacy_repos_search_arepothatdoesntexist.json').read
    else
      resp = "{}"
    end

    JSON.parse(resp)
  end
end
