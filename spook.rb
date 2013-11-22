require 'sinatra'
require 'json'

use Rack::Auth::Basic, 'Spook CF v2 Service' do |_, password|
  password == 'my_spook_pass'
end

class Spook < Sinatra::Base

  get '/v2/catalog' do
    body = {
      'services' => [
        {
          'id' => 'spook-service-1',
          'name' => 'spook-service',
          'description' => 'SpookV2 the friendly ghost',
          'bindable' => true,
          'tags' => ['awesome', 'spook', 'spook for devs'],
          'metadata' => {
            'listing' => {
              'imageUrl' => 'http://http://lorempixel.com/100/100/',
              'blurb' => 'Be afraid. Be VERY afraid.',
            },
          },
          'plans' => Database.plans,
        }
      ]
    }.to_json

    [200, {}, body]
  end

  put '/v2/service_instances/:service_instance_id' do
    json = JSON.parse(request.body.read)
    raise 'unexpected plan_id' unless json['plan_id'] == 'scary-plan'

    Database.instance_count += 1

    body = {
      'dashboard_url' => 'http://dashboard'
    }.to_json
    [201, {}, body]
  end

  put '/v2/service_instances/:service_instance_id/service_bindings/:service_binding_id' do
    json = JSON.parse(request.body.read)

    Database.binding_count += 1

    body = {
      'credentials' => {
        'username' => 'admin',
        'password' => 'secret'
      }
    }.to_json

    [200, {}, body]
  end

  delete '/v2/service_instances/:service_instance_id/service_bindings/:service_binding_id' do
    Database.binding_count -= 1

    [204, {}, '']
  end

  delete '/v2/service_instances/:service_instance_id' do
    Database.instance_count -= 1

    [204, {}, '']
  end

  get '/counts' do
    body = {
      instances: Database.instance_count,
      bindings: Database.binding_count
    }.to_json

    [200, {}, body]
  end

  delete '/plan/last' do
    Database.plans.pop
    [204, {}, nil]
  end

  module Database
    def self.instance_count=(value)
      @instance_count = value
    end

    def self.instance_count
      @instance_count ||= 0
    end

    def self.binding_count=(value)
      @binding_count = value
    end

    def self.binding_count
      @binding_count ||= 0
    end

    def self.plans
      @plans ||= [
        {
          'id' => 'scary-plan',
          'name' => 'Scary',
          'description' => 'This plan will make you tremble in your boots.',
          'metadata' => {
            'cost' => 0.0,
            'bullets' =>
              [
                {'content' => 'Awesome'},
                {'content' => 'Scary'},
                {'content' => 'A Plan'},
              ]
          }
        },
        {
          'id' => 'terrifying-plan',
          'name' => 'Terrifying',
          'description' => 'This plan will make your accountant tremble in his/her boots.'
        }
      ]
    end

  end

end
