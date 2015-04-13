class HomeController < ApplicationController

  def index
    @users = User.all
    @params = params.slice(:left_user, :right_user)
    @left_user = User.find_by(id: @params[:left_user])
    @right_user = User.find_by(id: @params[:right_user])
  end

  def reload
    app_access_token = Koala::Facebook::OAuth.new.get_app_access_token

    test_users = Koala::Facebook::TestUsers.new(app_id: Facebook::APP_ID, app_access_token: app_access_token)

    api = Koala::Facebook::API.new(app_access_token)
    users = api.get_objects(test_users.list.map { |user| user['id'] })

    users.each_value do |user|
      u = User.find_or_initialize_by(fb: user['id'])
      u.update!(name: user['name'])
    end

    redirect_to(action: :index)
  end

  # def oauth
  # end
end
