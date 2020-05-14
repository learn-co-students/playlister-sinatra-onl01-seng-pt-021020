require 'rack-flash'

class SongsController < ApplicationController
  enable :sessions
  set :session_secret, "my_application_secret"

  use Rack::Flash
  
  get '/songs' do
    @songs = Song.all

    erb :'songs/index'
  end

  post '/songs' do
    song = Song.new(name: params[:song][:name])
    if !params[:song][:artist].nil?
      song.artist = Artist.find(params[:song][:artist].to_i)
    elsif !(params[:new_artist_name] == '')
      artist = Artist.find_by(name: params[:new_artist_name])
      if artist.nil?
        artist = Artist.create(name: params[:new_artist_name])
      end
      song.artist = artist
    end

    if !params[:song][:genres].empty?
      for genre_id in params[:song][:genres]
        song.genres << Genre.find(genre_id)
      end
    end
    if !(params[:new_genre_name] == '')
      new_genre = Genre.find_by(name: params[:new_genre_name])
      if new_genre.nil?
        new_genre = Genre.create(name: params[:new_genre_name])
      end
      song.genres << new_genre
    end
    song.save

    flash[:message] = 'Successfully created song.'

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

  patch '/songs/:slug' do
    song = Song.all.select {|song| song.slug == params[:slug]}.first
    if !params[:song][:artist].nil?
      song.artist = Artist.find_by_id(params[:song][:artist].to_i)
    end
    if !(params[:new_artist_name] == '')
      artist = Artist.find_by(name: params[:new_artist_name])
      if artist.nil?
        artist = Artist.create(name: params[:new_artist_name])
      end
      song.artist = artist
    end

    song.genres = []
    if !params[:song][:genres].empty?
      for genre_id in params[:song][:genres]
        song.genres << Genre.find_by_id(genre_id)
      end
    end
    if !(params[:new_genre_name] == '')
      new_genre = Genre.find_by(name: params[:new_genre_name])
      if !new_genre.nil?
        new_genre = Genre.create(name: params[:new_genre_name])
      end
      song.genres << new_genre
    end
    song.save

    flash[:message] = 'Successfully updated song.'

    redirect to "/songs/#{song.slug}"
  end

  get '/songs/:slug/edit' do
    @song = Song.all.select {|song| song.slug == params[:slug]}.first
    @artists = Artist.all
    @genres = Genre.all

    erb :'songs/edit'
  end

end
