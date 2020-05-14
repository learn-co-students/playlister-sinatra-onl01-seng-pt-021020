class Artist < ActiveRecord::Base
  has_many :songs
  has_many :song_genres, through: :songs
  has_many :genres, through: :song_genres

  
  def self.find_by_slug(slug)
    self.all.select {|artist| artist.slug == slug}.first
  end


  def slug
    Slugifiable.slugify(self.name)
  end

end
