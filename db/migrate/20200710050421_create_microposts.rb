class CreateMicroposts < ActiveRecord::Migration
  def change
    create_table :microposts do |t|
      t.text :content
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
    add_index :microposts, [:user_id, :created_at] # user_idに関連づけられた全てのマイクロポストを作成時間の順で取り出しやすくする = 複合インデックス
  end
end
