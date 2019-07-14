# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AllowedAppsController, type: :routing do
  describe 'routing' do
    it 'routes to #index_user' do
      expect(get: '/users/1/allowed_apps').to route_to('allowed_apps#index_user', user_id: '1')
    end

    it 'routes to #index_app' do
      expect(get: '/apps/1/allowed_apps').to route_to('allowed_apps#index_app', app_id: '1')
    end

    it 'routes to #show' do
      expect(get: '/allowed_apps/1').to route_to('allowed_apps#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: 'allowed_apps/1/edit').to route_to('allowed_apps#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users/1/allowed_apps').to route_to('allowed_apps#create', user_id: '1')
    end

    it 'routes to #update via PUT' do
      expect(put: '/allowed_apps/1').to route_to('allowed_apps#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/allowed_apps/1').to route_to('allowed_apps#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/allowed_apps/1').to route_to('allowed_apps#destroy', id: '1')
    end
  end
end
