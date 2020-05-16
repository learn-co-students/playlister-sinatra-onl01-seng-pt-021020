class Slugifiable
  def self.slugify(string)
    string.gsub('$', 'S').gsub('&', 'and').gsub(/[^a-zA-Z0-9\ ]/, '').split.join('-').downcase
  end

end

