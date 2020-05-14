class Song < ActiveRecord::Base
  belongs_to :artist
  has_many :song_genres
  has_many :genres, through: :song_genres


  def self.find_by_slug(slug)
    self.all.select {|song| song.slug == slug}.first
  end


  def slug
    Slugifiable.slugify(self.name)
  end

end
