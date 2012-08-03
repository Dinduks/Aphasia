require 'net/https'
require 'json'

class Aphasia
  def self.repos(keyword)
    resp = self.call("/legacy/repos/search/#{keyword}")
    create_repos_array(resp['repositories'])
  end

  def self.user_repos(username)
    resp = self.call("/users/#{username}/repos")
    raise 'User not found!' if resp['message'].to_s == 'Not Found' if resp.is_a? Hash
    create_repos_array(resp)
  end

  private
  def self.call(path)
    http = Net::HTTP.new('api.github.com', 443)
    http.use_ssl = true
    req = Net::HTTP::Get.new(path)
    resp = http.request(req)
    JSON.parse(resp.body)
  end

  def self.create_repos_array(repositories)
    repositories_array = Array.new

    repositories.each do |repository_hash|
      repo = Repository.new.fill_from_hash(repository_hash)
      repositories_array.push(repo)
    end

    repositories_array
  end
end
