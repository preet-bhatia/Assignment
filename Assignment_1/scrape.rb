module Scrape
    def self.fetch_movie_urls(n)
        html_top_250 = URI.open('https://www.imdb.com/chart/top').read
        doc = Nokogiri::HTML(html_top_250)
        first_n_titles = doc.search('.titleColumn a').first(n)
        first_n_titles.map do |movie_url|
        'https://www.imdb.com' + movie_url['href']
        end
    end
  
    def self.scrape_movie(url)
        # currently we are taking 10 members for each movie 
        # change value of cast_members to increase it
        cast_members = 10
        header = {"User-Agent" => "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/113.0.0.0 Safari/537.36"}
        doc = Nokogiri::HTML(URI.open(url, header).read)
        title = doc.xpath('//*[@id="__next"]/main/div/section[1]/section/div[3]/section/section/div[2]/div[1]/h1/span').text
        cast = []
        for i in 1..cast_members
            ele = doc.xpath("//*[@id=\"__next\"]/main/div/section[1]/div/section/div/div[1]/section[4]/div[2]/div[2]/div[#{i}]/div[2]/a").text
            cast.push(ele)
        end
        return title,cast
    end
end