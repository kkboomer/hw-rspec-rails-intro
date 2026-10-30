require 'rails_helper'

describe MoviesController, type: :controller do
  describe 'searching TMDb' do
    before :each do
      @fake_results = [double('movie1'), double('movie2')]
    end

    it 'calls the model method that performs TMDb search' do
      expect(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
      get :search_tmdb, params: { title: 'hardware' }
    end

    describe 'after valid search' do
      before :each do
        allow(Movie).to receive(:find_in_tmdb).and_return(@fake_results)
        get :search_tmdb, params: { title: 'hardware' }
      end

      it 'selects the Search Results template for rendering' do
        expect(response).to render_template('search_tmdb')
      end

      it 'makes the TMDb search results available to that template' do
        expect(assigns(:movies)).to eq(@fake_results)
      end
    end

    context 'when search terms are invalid or empty' do
      it 'redirects to the movies path with a warning flash message' do
        get :search_tmdb, params: { title: '' }
        expect(response).to redirect_to(search_tmdb_path)
        expect(flash[:warning]).to eq('Please fill in all required fields!')
      end
    end

    context 'when the search yields no results' do
      it 'redirects to the movies path with a warning flash message' do
        allow(Movie).to receive(:find_in_tmdb).and_return([])
        get :search_tmdb, params: { title: 'NonexistentMovie123' }
        expect(response).to redirect_to(search_tmdb_path)
        expect(flash[:warning]).to eq('No movies found with given parameters!')
      end
    end
  end
end