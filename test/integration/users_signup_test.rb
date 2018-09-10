require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest

  def setup
    # Reset the 'deliveries' array to prevent
    # something breakin in case we have other tests who send emails ('deliveries' array is global)
    ActionMailer::Base.deliveries.clear
    @admin_user = users(:michael)
  end

  test "invalid signup information" do
    get signup_path
    assert_no_difference 'User.count' do
      post signup_path, params: { user: { name:  "",
                                         email: "user@invalid",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation' # Confirm the existence of a div with id 'error_explanation'
    assert_select 'div.alert' # Confirm the existence of a div with class 'alert'
    assert_select 'form#new_user[action=?]', '/signup' # Confirms the presence of a form with id 'new_user' whose 'action' attribute is equal to the value of '/signup'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size # Make sure exactly one message was delivered
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not is_logged_in?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
  end

  test "inability to view user details before activation" do
    post users_path, params: { user: { name:  "Example User",
                                         email: "user2@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    user = assigns(:user)
    log_in_as(users(:archer))
    get user_path(user)
    assert_redirected_to root_url

  end

end
