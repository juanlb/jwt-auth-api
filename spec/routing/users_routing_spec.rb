# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/users').to route_to('users#index')
    end

    it 'routes to #new' do
      expect(get: '/users/new').to route_to('users#new')
    end

    it 'routes to #show' do
      expect(get: '/users/1').to route_to('users#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/users/1/edit').to route_to('users#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/users').to route_to('users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/users/1').to route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/users/1').to route_to('users#destroy', id: '1')
    end

    it 'routes to #password' do
      expect(get: '/users/1/password').to route_to('users#password', id: '1')
    end

    it 'routes to #update password via POST' do
      expect(post: '/users/1/password').to route_to('users#update_password', id: '1')
    end

    it 'routes to #reset_user_key' do
      expect(get: '/users/1/reset_user_key').to route_to('users#reset_user_key', id: '1')
    end
  end
end
