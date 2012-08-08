class GitHubClient
  def initialize(api_url)
    @api_url = api_url
  end

  def call(path)
    http = Net::HTTP.new(@api_url, 443)
    http.use_ssl = true
    req = Net::HTTP::Get.new(path)
    resp = http.request(req)
    JSON.parse(resp.body)
  end
end
