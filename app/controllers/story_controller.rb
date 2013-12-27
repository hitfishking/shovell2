#encoding: UTF-8
class StoryController < ApplicationController
	before_filter :login_required, :only => [:new, :vote]

  def index
		#@story = Story.order("RAND()").first
		#@stories = Story.where("votes_count >= 5").order('id DESC')
		fetch_stories 'votes_count >= 5'
  end

	def bin
		fetch_stories 'votes_count < 5'
		render :action => 'index'
	end

  def new
	  #params.permit!
	  #@story = Story.new

	  if request.post?
		  @story = Story.new(story_params)  #所有表单上的字段均在params中。
		  @story.user = @current_user
		  if  @story.save
			  @story.tag_list = params[:tags] if params[:tags]   #保存到关联的tagging/tags表中。
			  @story.save
			  flash[:notice] = 'Story submission succeeded'
			  redirect_to action: 'index'
		  end
	  end
  end

  def show
		@story = Story.find_by_permalink(params[:permalink])
  end

  def vote
		#@story = Story.find(story_params[:id])
		@story = Story.find(params[:id])
		@story.votes.create(:user => @current_user)

		respond_to do  |format|
			format.js
			format.html
		end
  end

	def tag
		@stories = Story.tagged_with(params[:id])
		render :action => 'index'
	end

	protected
	def fetch_stories(conditions)
		benchmark('Fetching stories') do
			@stories = Story.where(conditions).order('id DESC')
		end
	end

  private
  def story_params
	  params.require(:story).permit(:name,:link,:permalink,:description,:tags)
  end

end
