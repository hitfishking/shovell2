require 'test_helper'

class StoryControllerTest < ActionController::TestCase

  test "should show index" do
    get :index
    assert_response :success
	  assert_template 'index'
	  assert_not_nil assigns(:stories)
  end

  test "should show new" do
	  get_with_user :new
	  #post :new, :stroy => {
			#  :name => 'test story',
			#  :link => 'http://www.test.com/'
	  #}

	  assert_response :success
	  assert_template 'new'
	  #assert_not_nil assigns(:story)
  end

  test "should show new form" do
	  get_with_user :new
	  assert_select 'form p', :count => 5
  end

	test "should add story" do
		post_with_user :new, :story => {
				:name => 'test story',
		    :link => 'http://www.test.com/'
		}
		assert !assigns(:story).new_record?, '@story should contain a new record'
		assert_redirected_to :action => 'index'
		assert_not_nil flash[:notice]
	end

	test "should reject missing story attribute" do
		post_with_user :new, :story => {
				:name => 'story without a link'
		}
		assert assigns(:story).errors.include?(:link)
	end

	test "should show story" do
		get :show, :permalink => 'my-shiny-weblog'
		assert_response :success
		assert_template 'show'
		assert_equal assigns(:story), stories(:first)
	end

	#测试故事显示页面
	test "should show story vote elements" do
		get_with_user :show, :permalink => 'my-shiny-weblog'
		assert_select 'h2 span#vote_score'
		assert_select 'ul#vote_history li', :count => 2
		assert_select 'div#vote_link'
	end

	test "should not show vote button if not logged in" do
		get :show, :permalink => 'my-shiny-weblog'
		assert_select 'div#vote_link', false
	end

	test "should accept vote" do
		assert stories(:second).votes.empty?
		post_with_user :vote, :id => 2
		assert !assigns(:story).reload.votes.empty?
	end

	test "should render rjs after vote with ajax" do
		xml_http_request :post_with_user, :vote, :id => 2
		assert_response :success
		assert_template 'vote'
	end

	#测试故事提交人显示
	test "should show story submitter" do
		get :show, :permalink => 'my-shiny-weblog'
		assert_select 'p.submitted_by span', 'patrick'
	end

	#测试全局元素显示 - login/logout menu
	test "should indicate not logged in" do
		get :index
		assert_select 'div#login_logout em', 'Not Logged in.'
	end

	#测试全局元素显示 - 底部导航链接
	test "should show navigation menu" do
		get :index
		assert_select 'ul#navigation li', 3
	end

  test "should indicate logged in user" do
	  get_with_user :index
	  assert_equal users(:patrick), assigns(:current_user)
	  assert_select 'div#login_logout em a', '(Logout)'
  end

  #测试注销后重定向
  test "should redirect if not logge in" do
	  get :new
	  assert_response :redirect
	  assert_redirected_to '/account/login'
  end

  test "should store user with story" do
	  post_with_user :new, :story => {
			  :name => 'story with user',
	      :link => 'http://www.story-with-user.com/'
	  }
	  assert_equal users(:patrick), assigns(:story).user
  end

  #测试模板的使用
  test "should show bin" do
	  get :bin
	  assert_response :success
	  assert_template :index
  end

  test "should only list promoted on index" do
	  get :index
	  assert_equal [stories(:promoted)], assigns(:stories)
  end

  test "should only list unpromoted in bin" do
	  get :bin
	  assert_equal [stories(:second),stories(:first)], assigns(:stories)
  end

  #测试默认路由配置
  test "should use story index as default" do
		assert_routing  "", :controller => 'story', :action => 'index'
  end

	#测试页面标题
	test "should show story on index" do
		get :index
		assert_select 'h2', 'Showing 1 FRONT PAGE story.'
		assert_select 'div#content div.story', :count => 1
	end

	test "should show stories in bin" do
		get :bin
		assert_select 'h2', 'Showing 2 UPCOMING stories.'
		assert_select 'div#content div.story', :count => 2
	end

	#测试用户投票历史
	test "should store user with vote" do
		post_with_user :vote, :id => 2
		assert_equal users(:patrick), assigns(:story).votes.last.user
	end

  #测试带标签的新故事的提交
  test "should add story with tags" do
	  post_with_user :new, :tags => 'rails,blog',
	                        :story => {
			                        :name => 'story with tags',
	                            :link => 'http://www.story-with-tags.com/'
	                        }
	  assert_equal ['rails','blog'],assigns(:story).tag_list
  end

  #测试故事页面的标签显示
  test "should show story with tags" do
	  stories(:promoted).tag_list = 'apple,music'
	  stories(:promoted).save
	  get :show, :permalink => 'promoted-story'
	  assert_select 'p.tags a',2
  end

  #测试标签列出相关标记故事的动作
  test "should find tagged stories" do
	  stories(:first).tag_list = 'book,english'
	  stories(:first).save
	  get :tag, :id => 'book'
	  assert_equal [stories(:first)], assigns(:stories)
  end

  #测试通过标签显示故事
  test "should render tagged stories" do
	  stories(:first).tag_list = 'book,english'
	  stories(:first).save
	  get :tag, :id => 'english'
	  assert_response :success
	  assert_template :index
	  assert_select 'div#content div.story', :count => 1

  end

  protected
  def get_with_user(action, parameters = nil, session = nil, flash = nil)
	  get action, parameters, :user_id => users(:patrick).id
  end
  def post_with_user(action, parameters = nil, session = nil, flash = nil)
	  post action, parameters, :user_id => users(:patrick).id
  end

end
