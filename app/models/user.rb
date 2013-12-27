class User < ActiveRecord::Base
	has_many :stories
	has_many :votes
	has_many :stories_votes_on, :through => :votes, :source => :story
end
