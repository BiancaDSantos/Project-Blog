class TagPost < ApplicationRecord
  belongs_to :tag
  belongs_to :post_revision

  scope :active, -> { where(active: true) }
  validates :post_revision_id, uniqueness: { scope: :tag_id, message: "Já existe uma associação para esta tag e revisão." }
end
