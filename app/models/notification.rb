class Notification < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  # -> {}でProcオブジェクトを作成している。Procオブジェクトはブロックをオブジェクト化している
  # -> アロー演算子
  belongs_to :post,    optional: true
  belongs_to :comment, optional: true
  # belongs_toが通常はnilを許さないため、optional: trueでnilを許可します。
  # 必要な情報以外はnilを格納するようにします。
  belongs_to :visitor, class_name: 'User', foreign_key: 'visitor_id', optional: true
  belongs_to :visited, class_name: 'User', foreign_key: 'visited_id', optional: true

end
