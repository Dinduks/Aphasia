class GitHubClientMock
  def call(path = '', dirname = File.dirname(__FILE__) + '/../../resources/')
    resp = begin
      File.open(dirname + path.gsub('/', '_')[1, path.length] + '.json').read
    rescue
      "{}"
    end

    JSON.parse(resp)
  end
end
