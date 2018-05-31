class CreatePost < ActiveRecord::Migration
  def change
      create_table :posts do |t|
          t.string :course
          t.integer :score
          t.string :date
          t.integer :user_id
      end
  end
end
