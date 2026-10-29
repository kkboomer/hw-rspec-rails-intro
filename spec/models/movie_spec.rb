require 'rails_helper'
require 'spec_helper'

describe Movie, type: :model do
  describe 'searching Tmdb by keyword' do
    it 'calls Faraday gem with CS169 domain' do
      expect(Faraday).to receive(:get).and_call_original
      Movie.find_in_tmdb({ title: 'hardware', language: 'en' })
    end

    it 'calls Tmdb with valid API key' do
      Movie.find_in_tmdb({ title: 'hacker', language: 'en' })
    end
  end
end