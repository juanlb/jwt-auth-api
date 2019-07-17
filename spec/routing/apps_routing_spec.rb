# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AppsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/apps').to route_to('apps#index')
    end

    it 'routes to #new' do
      expect(get: '/apps/new').to route_to('apps#new')
    end

    it 'routes to #show' do
      expect(get: '/apps/1').to route_to('apps#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/apps/1/edit').to route_to('apps#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/apps').to route_to('apps#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/apps/1').to route_to('apps#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/apps/1').to route_to('apps#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/apps/1').to route_to('apps#destroy', id: '1')
    end

    it 'routes to #reset_app_key' do
      expect(get: '/apps/1/reset_app_key').to route_to('apps#reset_app_key', id: '1')
    end

    it 'routes to #reset_rsa_key_pair' do
      expect(get: '/apps/1/reset_rsa_key_pair').to route_to('apps#reset_rsa_key_pair', id: '1')
    end
  end
end
