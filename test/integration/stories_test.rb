require 'test_helper'

class StoriesTest < ActionDispatch::IntegrationTest
	def test_story_submission_with_login
		get '/story/new'
		#breakpoint
		assert_response :redirect
		follow_redirect!

		assert_response :success
		assert_template 'account/login'
		post '/account/login', :login => 'patrick', :password => 'sekrit'
		assert_response :redirect
		follow_redirect!

		assert_response :success
		assert_template 'story/new'
		post 'story/new', :story => {
				:name => 'Submission from Integration Test',
		    :link => 'http://integration_test.com/'
		}
		assert_response :redirect
		follow_redirect!

		assert_response :success
		assert_template 'story/index'
	end
end