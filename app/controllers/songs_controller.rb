# require 'rack-flash'

class SongsController < ApplicationController
  
  get '/songs' do
    @songs = Song.all

    erb :'songs/index'
  end

  post '/songs' do
    song = Song.new(params[:song])

    binding.pry

    if !song.artist.nil? && !!params[:new_artist_name]
      song.artist = Artist.create(params[:new_artist_name])
    end
    if !!params[:new_genre_name]
      song.genres << Genre.create(params[:new_genre_name])
    end
    song.save

    redirect to "/songs/#{song.slug}"
  end

  get '/songs/new' do
    @artists = Artist.all
    @genres = Genre.all

    erb :'songs/new'
  end

  get '/songs/:slug' do
    @song = Song.all.select {|song| song.slug == params[:slug]}.first

    erb :'songs/show'
  end

end
