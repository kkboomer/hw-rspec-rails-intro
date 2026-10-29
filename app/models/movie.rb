class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end
  def self.find_in_tmdb(search_params, key = "d03a80725c289ace3b9ff0217b34efcd")
    # Handle both Hash/Parameters and plain String (in case an old spec passes a string)
    if search_params.is_a?(String)
      title = search_params
      release_year = nil
      language = nil
    else
      title = search_params[:title] || search_params['title'] || search_params[:search_terms] || search_params['search_terms']
      release_year = search_params[:release_year] || search_params['release_year'] || search_params[:year] || search_params['year']
      language = search_params[:language] || search_params['language']
    end

    query_params = { api_key: key, query: title }
    query_params[:year] = release_year if release_year.present?
    query_params[:language] = language if language.present? && language != 'all'

    uri = "https://api.themoviedb.org/3/search/movie?#{URI.encode_www_form(query_params)}"
    response = Faraday.get(uri)
    results = JSON.parse(response.body)["results"] || []

    results.map do |movie_hash|
      Movie.new(
        title: movie_hash["title"],
        rating: "R",
        release_date: movie_hash["release_date"],
        description: movie_hash["overview"]
      )
    end
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end
end
