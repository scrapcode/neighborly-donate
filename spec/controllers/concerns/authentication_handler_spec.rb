require 'spec_helper'

describe Concerns::AuthenticationHandler, type: :controller do
  let(:controller) { ApplicationController.new }

  describe '#base_domain' do
    it 'returns a hash with proper domain' do
      ENV['BASE_DOMAIN'] = 'login.example.com'
      expect(controller.base_domain).to eq(host: 'login.example.com')
    end
  end
end
