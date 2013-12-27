class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
	    t.column :story_id, :integer
      t.timestamps
    end
  end
end
