require 'test_helper'

class UserTest < ActiveSupport::TestCase

	test "stories association" do
		assert_equal 2, users(:patrick).stories.size
		assert_equal stories(:first), users(:patrick).stories.first
	end

	test "votes association" do
		assert_equal 1, users(:patrick).votes.size
		assert_equal votes(:second), users(:john).votes.first
	end

	#测试join关系模型
	test "stories voted on association" do
		assert_equal [stories(:first)], users(:patrick).stories_votes_on
	end

end
