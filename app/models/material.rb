class Material < ApplicationRecord
  has_many :material_evaluations, dependent: :destroy
  has_many :likes, dependent: :destroy

  validates :title, presence: true, uniqueness: true
  validates :image_link, presence: true, uniqueness: true

  # データを同時に保存する
  accepts_nested_attributes_for :material_evaluations, allow_destroy: true

  # 教材並び替え
  scope :order_by_published_date, lambda {
    order(Arel.sql('published_date IS NULL, published_date DESC'))
  }
  scope :order_by_evaluation_average, lambda {
    left_joins(:material_evaluations)
      .select('materials.*, AVG(material_evaluations.evaluation) AS evaluation_average')
      .group('materials.id')
      .order('evaluation_average DESC')
  }

  # 検索
  def self.ransackable_attributes(_auth_object = nil)
    %w[title created_at id image_link info_link published_date systemid updated_at qualification]
  end

  def self.ransackable_associations(_auth_object = nil)
    %w[likes material_evaluations] # 検索可能にしたいアソシエーションをリスト
  end
end
