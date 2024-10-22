FactoryBot.define do
  factory :qualification do
    name { "資格名" }
    progress { "学習中" }
    association :user  # userの関連を追加
  end
end
