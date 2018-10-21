class UsersController < ActionController::Base
  def spotify
    Log.create!(
      data: {
        omniauth: request.env['omniauth.auth'],
        params:   params,
        headers:  headers
      }
    )
    _, user =
      User::CreateFromSpotifyOmniauth
      .new(auth_params: request.env['omniauth.auth'])
      .call

    redirect_to user_path(user)
  end

  def index
    render template: 'users/index'
  end

  def show
    render template: 'users/show',
           locals:   User::Show.new(user: user).call
  end

  def user
    @user ||= User.find_by(id: params[:id])
  end
end
