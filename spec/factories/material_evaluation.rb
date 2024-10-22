FactoryBot.define do
  factory :material_evaluation do
    evaluation { "3.0" }
    body { "教材評価コメント" }
    association :user  # userを関連付ける
    association :material  # materialを関連付ける
  end
end