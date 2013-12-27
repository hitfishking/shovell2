require 'test_helper'

class VoteTest < ActiveSupport::TestCase
	test "story association"  do
		assert_equal stories(:first), votes(:first).story
	end

	test "user association" do
		assert_equal users(:john), votes(:second).user
	end
end
