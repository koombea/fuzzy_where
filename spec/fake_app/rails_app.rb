# require 'rails/all'
require 'action_controller/railtie'
require 'action_view/railtie'

require 'fake_app/active_record/config' if defined? ActiveRecord
# config
app = Class.new(Rails::Application)
app.config.secret_token = '957d9f90e559b205b137dbf86d429a8fdfdfa9851cdfc0c4a38acfc372e2383916641985806efd35861bbc401f74a7adce59667caf91799804a0d797179713b6'
app.config.session_store :cookie_store, :key => '_myapp_session'
app.config.active_support.deprecation = :log
app.config.eager_load = false
# Rais.root
app.config.root = File.dirname(__FILE__)
Rails.backtrace_cleaner.remove_silencers!
app.initialize!

# routes
app.routes.draw do
  resources :people
end

#models
require 'fake_app/active_record/models' if defined? ActiveRecord

# controllers
class ApplicationController < ActionController::Base;
end
class UsersController < ApplicationController
  def index
    @people = Person.fuzzy_where(age: :young)
    render :inline => <<-ERB
<%= @people.map(&:name).join("\n") %>
    ERB
  end
end

# helpers
Object.const_set(:ApplicationHelper, Module.new)
