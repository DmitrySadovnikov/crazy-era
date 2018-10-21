class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, uniq: true, null: false
      t.string :session_token
      t.jsonb :data, default: {}

      t.timestamps
    end
  end
end
