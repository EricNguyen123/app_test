require 'rails_helper'

RSpec.describe User, type: :model do
  it 'should have a valid factory' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end
end

RSpec.describe SessionsController, type: :controller do
  it 'should have a valid factory' do
    user = FactoryBot.create(:user)
    expect(user).to be_valid
  end

  it 'user login' do
    get :new
    expect(response).to render_template(:new)
  end

  it 'sessions new' do
    user = FactoryBot.create(:user)
    post :create, params: { session: { email: user.email, password: user.password } }
    expect(response).to redirect_to root_url
  end

  it 'login with third party' do
    user = FactoryBot.create(:user) # Tạo người dùng
    allow(User).to receive(:new).and_return(user)
    allow(user).to receive(:login_with_third_party).and_return(user)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] = OmniAuth::AuthHash.new({
                                                                         'provider' => 'google_oauth2',
                                                                         'uid' => '111111111111111111',
                                                                         'info' => {
                                                                           'nick_name' => 'John Smith',
                                                                           'name' => 'John Smith',
                                                                           'email' => 'john@example.com',
                                                                           'first_name' => 'John',
                                                                           'last_name' => 'Smith',
                                                                           'image' => 'https://lh4.googleusercontent.com/photo.jpg',
                                                                           'urls' => {
                                                                             'google' => 'https://plus.google.com/+JohnSmith'
                                                                           }
                                                                         },
                                                                         'credentials' => {
                                                                           'token' => 'TOKEN',
                                                                           'refresh_token' => 'REFRESH_TOKEN',
                                                                           'expires_at' => 1_496_120_719,
                                                                           'expires' => true
                                                                         },
                                                                         'extra' => {
                                                                           'id_token' => 'ID_TOKEN',
                                                                           'id_info' => {
                                                                             'azp' => 'APP_ID',
                                                                             'aud' => 'APP_ID',
                                                                             'sub' => '100000000000000000000',
                                                                             'email' => 'john@example.com',
                                                                             'email_verified' => true,
                                                                             'at_hash' => 'HK6E_P6Dh8Y93mRNtsDB1Q',
                                                                             'iss' => 'accounts.google.com',
                                                                             'iat' => 1_496_117_119,
                                                                             'exp' => 1_496_120_719
                                                                           },
                                                                           'raw_info' => {
                                                                             'sub' => '100000000000000000000',
                                                                             'name' => 'John Smith',
                                                                             'given_name' => 'John',
                                                                             'family_name' => 'Smith',
                                                                             'profile' => 'https://plus.google.com/+JohnSmith',
                                                                             'picture' => 'https://lh4.googleusercontent.com/photo.jpg?sz=50',
                                                                             'email' => 'john@example.com',
                                                                             'email_verified' => 'true',
                                                                             'locale' => 'en',
                                                                             'hd' => 'company.com'
                                                                           }
                                                                         }
                                                                       })
    request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    get :omniauth
    expect(response).to redirect_to(root_url)
  end

  describe 'POST #create' do
    it 'redirects to root_url with warning when account is not activated' do
      user = FactoryBot.create(:user, activated: false)
      post :create, params: { session: { email: user.email, password: user.password } }
      expect(response).to redirect_to(root_url)
      expect(flash[:warning]).to be_present
    end

    it 'renders new template with danger flash message on invalid credentials' do
      user = FactoryBot.create(:user) # Ensure user exists
      post :create, params: { session: { email: user.email, password: 'invalid_password' } }
      expect(response).to render_template(:new)
      expect(flash[:danger]).to be_present
    end
  end

  describe 'GET #omniauth' do
    it 'redirects to login_path on invalid third-party login' do
      # Stub a third-party login that is invalid or fails
      allow_any_instance_of(User).to receive(:login_with_third_party).and_return(User.new)
      get :omniauth
      expect(response).to redirect_to(login_path)
    end
  end
end
