class CreateStories < ActiveRecord::Migration
	def change
		create_table :stories, :force => true do |t|
			t.column :name, :string
			t.column :link, :string
			t.timestamps
		end
	end
end
