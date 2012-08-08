class Repository
  attr_accessor :html_url, :url, :id, :owner, :name, :full_name,
    :description, :homepage, :language, :private, :fork, :forks, :watchers,
    :size, :pushed_at, :created_at, :updated_at, :commits, :contributors

  def fill_from_hash!(repository_hash)
    repository_hash.each do |k, v|
      begin
        self.send(k, v)
      rescue
      end
    end
    self.languages = [repository_hash['language']]
    self
  end
end
