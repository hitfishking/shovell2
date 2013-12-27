module StoryHelper
	def story_list_heading
		#story_type = case controller.action_name
		 story_type = case params[:action].to_s
		   	            when 'index';   then 'FRONT PAGE '
			              when 'bin';     then 'UPCOMING '
									  when 'tag';     then 'TAGGED '
		              end
		 #story_single = "#{story_type} story"
		 #story_multi = "#{story_type} stories"
		"Showing #{ pluralize(@stories.size,story_type+'story.',story_type+'stories.')}"

	end
end
