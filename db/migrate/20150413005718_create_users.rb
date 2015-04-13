class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.bigint :fb
      t.index :fb
    end
  end
end
