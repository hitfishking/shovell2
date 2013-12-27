require 'test_helper'

class AccountControllerTest < ActionController::TestCase
  #测试登录表单显示
	test "should show login form" do
    get :login
    assert_response :success
	  assert_template 'login'
	  assert_select 'form p',4
  end

  #测试退出登录界面显示
	test "should get logout" do
    get :logout
    assert_response :success
  end

	#测试成功登录
	test "should perform user login" do
		post :login, :login => 'patrick', :password => 'sekrit'
		assert_redirected_to :controller => 'story'
		assert_equal users(:patrick).id, session[:user_id]
		assert_equal users(:patrick), assigns(:current_user)
	end

	#测试登录失败
	test "should fail user login" do
		post :login, :login => 'no such', :password => 'user'
		assert_response :success
		assert_template 'login'
		assert_nil session[:user_id]
	end

	#测试登录后重定向
	test "should redirect after login with return url" do
		post :login, { :login => 'patrick', :password => 'sekrit'}, :return_to => '/story/new'
		assert_redirected_to '/story/new'
	end

	#测试注销
	test "should logout and clear session" do
		post :login, :login => 'patrick', :password => 'sekrit'
		assert_not_nil assigns(:current_user)
		assert_not_nil session[:user_id]

		get :logout
		assert_response :success
		assert_template 'logout'
		assert_select 'h2', 'Logout successful'

		assert_nil assigns(:current_user)
		assert_nil session[:user_id]
	end

	test "should show user" do
		get :show, :id => 'patrick'
		assert_response :success
		assert_template :show
		assert_equal users(:patrick), assigns(:user)
	end

	test "should show submitted stories" do
		get :show, :id => 'patrick'
		assert_select 'div#stories_submitted div.story', :count => 2
	end

	test "should show stories voted on" do
		get :show, :id => 'patrick'
		assert_select 'div#stories_voted_on div.story', :count => 1
	end

end
