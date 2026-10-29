class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end
  def self.find_in_tmdb(search_params, key="d03a80725c289ace3b9ff0217b34efcd")
    # Faraday will automatically encode spaces and format the ?query=... string
    response = Faraday.get('https://api.themoviedb.org/3/search/movie', {
      api_key: key,
      query: search_params[:title] || search_params['title'],
      language: search_params[:language] || search_params['language'],
      year: search_params[:release_year] || search_params['release_year']
    })
    res = JSON.parse(response.body)
    res["results"]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
end
