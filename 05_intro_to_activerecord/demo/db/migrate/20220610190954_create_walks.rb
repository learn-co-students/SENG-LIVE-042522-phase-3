class CreateWalks < ActiveRecord::Migration[6.1]
  def change
    create_table :walks do |t|
      t.datetime :time
      t.integer :dog_id
      # or this (which gives an index to make has many queries faster
      # and a foreign key constraint to raise errors if the foreign key is invalid -- doesn't point to an existing dog)
      # t.belongs_to :dog, foreign_key: true, null: false
    end
  end
end
