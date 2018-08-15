require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest

  # 'setup' is a special function that will be executed before
  # each test
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
  end

  test "should get root" do
    # 'root_path' and 'root_url' are formed automatically by rails
    # According to what we entered in the routes file under root
    get root_path
    assert_response :success
    assert_select "title", "#{@base_title}"
  end


  test "should get help" do
    # 'help_path' and 'help_url' are formed automatically by rails
    # according to what we entered in the routes file under '/help'
    get help_path
    assert_response :success
    assert_select "title", "Help | #{@base_title}"
  end

  test "should get about" do
    # 'about_path' and 'about_url' are formed automatically by rails
    # according to what we entered in the routes file under '/about'
    get about_path
    assert_response :success
    assert_select "title", "About | #{@base_title}"
  end

  test "should get contact" do
    # 'contact_path' and 'contact_url' are formed automatically by rails
    # according to what we entered in the routes file under '/contact'
    get contact_path
    assert_response :success
    assert_select "title", "Contact | #{@base_title}"
  end

end