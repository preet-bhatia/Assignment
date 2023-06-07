require 'open-uri'
require 'nokogiri'

def fetch_movie_urls(n)
  html_top_250 = URI.open('https://www.imdb.com/chart/top').read
  doc = Nokogiri::HTML(html_top_250)
  first_n_titles = doc.search('.titleColumn a').first(n)
  first_n_titles.map do |movie_url|
    'https://www.imdb.com' + movie_url['href']
  end
end

def scrape_movie(url)
    # currently we are taking 3 members for each movie 
    # change value of cast_members to increase it
    cast_members = 3
    header = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"}
    doc = Nokogiri::HTML(URI.open(url, header).read)
    title = doc.xpath('//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/h1/span').text
    cast = []
    for i in 1..cast_members
        ele = doc.xpath("//*[@id=\"__next\"]/main/div/section[1]/section/div[3]/section/section/div[3]/div[2]/div[1]/section/div[2]/div/ul/li[3]/div/ul/li[#{i}]/a").text
        cast.push(ele)
    end
    return title,cast
end

def getInput
    puts "Enter cast and number of movies (or exit)"
    gets.chomp
end

def fetch_data(num_of_movie)
    arr = fetch_movie_urls(num_of_movie)
    movies = {}
    num_of_movie.times do |ind|
        data = scrape_movie(arr[ind])
        movies[ind+1] = {
            :name => data[0],
            :cast => data[1]
        } 
    end
    # our movies hash will loke like this
    # movies = {
    #     1=> {:name=>"The Shawshank Redemption", :cast=> ["Tim Robbins","Morgan Freeman","Bob Gunton"]},
    #     2=> {:name=>"The Godfather", :cast=> ["Marlon Brando","Al Pacino","James Caan"]},
    #     3=> {:name=> "The Dark Knight", :cast=> ["Christian Bale","Heath Ledger","Morgan Freeman"]}
    # }
    return movies
end

def build_cast_info(num_of_movie, movies)
    cast = {}
    # as we are traversing movies data in order so 
    # cast will automatically be in order wise
    # so top movies will be top elements of array
    for i in 1..num_of_movie
        for actor in movies[i][:cast]
            # storing in downcase so case up/down
            # will also result correct answer
            actor.downcase!
            if !cast[actor]
                cast[actor] = [movies[i][:name]]
            else
                cast[actor].push(movies[i][:name])
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