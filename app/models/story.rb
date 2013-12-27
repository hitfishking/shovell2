class Story < ActiveRecord::Base
	acts_as_taggable_on :tags

	before_create :generate_permalink
	validates_presence_of :name,:link
	has_many :votes
	belongs_to :user

	def latest_votes
		votes.order('id DESC').take(3)
	end

	protected
	def generate_permalink
		self.permalink = name.downcase.gsub(/\W/, '-')
	end
end
