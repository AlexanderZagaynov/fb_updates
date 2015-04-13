class HomeController < ApplicationController

  def index
    @users = User.all
    @params = params.slice(:left_user, :right_user)
    @left_user = User.find_by(id: @params[:left_user])
    @right_user = User.find_by(id: @params[:right_user])
    get_friends(@left_user)
    get_friends(@right_user)
    @subscriptions = realtime.list_subscriptions
  end

  def reload
    test_users_api = Koala::Facebook::TestUsers.new(credentials)

    user_ids = []
    test_users_api.list.each do |user|
      user_ids << user['id']
      u = User.find_or_initialize_by(fb: user['id'])
      u.update!(token: user['access_token'])
    end

    users = Koala::Facebook::API.new(app_access_token).get_objects(user_ids)
    users.each_value do |user|
      u = User.find_or_initialize_by(fb: user['id'])
      u.update!(name: user['name'])
    end

    redirect_to(action: :index)
  end

  def verify
    # subs_url = Rails.application.routes.url_helpers.subs_url(host: 'http://localhost:3000')
    # ups.subscribe("user", "friends", subs_url, Facebook::SVToken)
    Koala::Facebook::RealtimeUpdates.meet_challenge(params, Facebook::SVToken)
    head :ok
  end

  def subscribe
  end

  private

  def app_access_token
    @app_access_token ||= Koala::Facebook::OAuth.new.get_app_access_token
  end

  def credentials
    @credentials ||= { app_id: Facebook::APP_ID, app_access_token: app_access_token }
  end

  def get_friends(user)
    return unless user && user.token
    api = Koala::Facebook::API.new(user.token)
    user.friends = api.get_connections("me", "friends")
  end

  def realtime
    @realtime ||= Koala::Facebook::RealtimeUpdates.new(credentials)
  end

end
