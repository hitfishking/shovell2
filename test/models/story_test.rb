require 'test_helper'

class StoryTest < ActiveSupport::TestCase
	#test "the truth" do
	#   assert true
	#end
	def test_should_require_name
		s = Story.create(:name => nil)
		assert s.errors.include?(:name)
	end

	def test_should_require_link
		s = Story.create(:link => nil)
		assert s.errors.include?(:link)
	end

	def test_should_create_user
		s = Story.create(
				:name => "My test submission",
				:link => "http://www.testsubmission.com/"
		)
		assert s.valid?
	end
	test "should_create_user2" do
		s = Story.create(
				:name => "",
		    :link => "http://www.testsubmission.com/"
		)
		assert s.invalid?,  "Cannot be empty!!!"
	end
	test "vote association" do
		assert_equal [votes(:first),votes(:second)], stories(:first).votes
	end

	test "should return highest vote id first" do
		assert_equal votes(:second), stories(:first).latest_votes.first
	end

	test "should return 3 latest votes" do
		10.times { stories(:first).votes.create}
		assert_equal 3, stories(:first).latest_votes.size
	end

	test "user association" do
		assert_equal users(:patrick), stories(:first).user
	end

	#测试附加的计数器缓存
	test "should increment votes counter cache" do
		stories(:second).votes.create
		stories(:second).reload
		assert_equal 1, stories(:second).attributes['votes_count']
	end

	#测试计数器缓存删除
	test "should decrement votes counter cache" do
		stories(:first).votes.first.destroy
		stories(:first).reload
		assert_equal 1, stories(:first).attributes['votes_count']
	end

	#测试permalink的生成
	test "should generate permalink" do
		s = Story.create(
				:name => 'This#title*is&full/of:special;characters',
		    :link => 'http://example.com/'
		)
		assert_equal 'this-title-is-full-of-special-characters', s.permalink
	end

	#测试标签的赋值
	test "should act as taggable" do
		stories(:first).tag_list = "book,english"
		stories(:first).save
		assert_equal 2, stories(:first).tags.size
		assert_equal ['book','english'], stories(:first).tag_list
	end

	#测试根据标签查找故事
	test "should find tagged with" do
		stories(:first).tag_list = "book, english"
		stories(:first).save
		assert_equal [stories(:first)], Story.tagged_with('book')
	end
end
