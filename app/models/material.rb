class Material < ApplicationRecord
  has_many :material_evaluations, dependent: :destroy
  has_many :likes, dependent: :destroy
  # 中間テーブル
  has_many :material_qualifications, dependent: :destroy
  has_many :qualification, through: :material_qualifications

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

  def self.ransackable_attributes(_auth_object = nil)
    %w[title created_at id image_link info_link published_date systemid updated_at]
  end
end
