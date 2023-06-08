require 'open-uri'
require 'nokogiri'
require_relative 'scrape'

class Movie
    attr_reader :name,:cast
    def initialize(name,cast)
        @name = name
        @cast = cast
    end
end

def getInput
    puts "Enter cast and number of movies (or exit)"
    gets.chomp
end

def fetch_data(num_of_movie)
    arr = Scrape.fetch_movie_urls(num_of_movie)
    movies = {}
    num_of_movie.times do |ind|
        data = Scrape.scrape_movie(arr[ind])
        movie = Movie.new(data[0],data[1])
        movies[ind+1] = movie
    end
    return movies
end

def build_cast_info(num_of_movie, movies)
    cast = {}
    # as we are traversing movies data in order so 
    # cast will automatically be in order wise
    # so top movies will be top elements of array
    for i in 1..num_of_movie
        for actor in movies[i].cast
            # storing in downcase so case up/down
            # will also result correct answer
            actor.downcase!
            if !cast[actor]
                cast[actor] = [movies[i].name]
            else
                cast[actor].push(movies[i].name)
            end
        end       
    end
    return cast
end


puts "Enter number of movies"
num_of_movie = gets.chomp.to_i
puts "Started: Fetching data from IMDB"
movies = fetch_data(num_of_movie)
puts "Completed: Fetching data from IMDB"
# build cast hash from movies db to optimise query
cast = build_cast_info(num_of_movie,movies)

while (input = getInput) != "exit"
    query = input.split
    actor= query[0..-2].join(" ").downcase
    topMovie = query[-1].to_i
    if topMovie < 1
        puts "Number of movies is not a correct value"
        next
    end
    actedMovies = cast[actor]
    if actedMovies!=nil
        counter = 0
        for movie in actedMovies
            if counter == topMovie
                break
            end
            puts movie
            counter+=1
        end
        puts "Cast #{actor} have less than #{topMovie} movies in current data" if counter < topMovie
    else
        puts "No movie found for cast #{actor}"
    end
end