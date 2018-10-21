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

    session['user_session_token'] = user.session_token
    redirect_to user_path(user)
  end

  def index
    render template: 'users/index'
  end

  def show
    render template: 'users/show',
           locals:   User::Show.new(user: current_user).call
  end

  def logout
    current_user.update!(session_token: nil)
    session['user_session_token'] = nil
    redirect_to :back
  end

  def current_user
    @current_user ||= User.find_by(session_token: session['user_session_token'])
  end
end
