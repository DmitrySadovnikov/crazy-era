class CreateLogs < ActiveRecord::Migration[5.2]
  def change
    create_table :logs, id: :uuid do |t|
      t.jsonb :data, default: {}
      t.timestamps
    end
  end
end
