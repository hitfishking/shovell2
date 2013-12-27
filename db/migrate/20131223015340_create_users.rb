class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
	    t.column :login, :string
	    t.column :password, :string
	    t.column :name, :string
	    t.column :email, :string
      t.timestamps
    end
		add_column :stories, :user_id, :integer
		add_column :votes, :user_id, :integer
  end
end
