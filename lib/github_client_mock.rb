class GitHubClientMock
  def call(path)
    begin
      resp = File.open(File.dirname(__FILE__) + "/../resources/#{path.gsub('/', '_')[1, path.length]}.json").read
    rescue
      resp = "{}"
    end

    JSON.parse(resp)
  end
end
