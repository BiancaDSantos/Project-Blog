class PostRevision < ApplicationRecord
  belongs_to :post
  scope :active, -> { where(active_revision: true) }
  validates :title, presence: { message: "O campo título deve ser preenchido" }, length: { maximum: 300}
  validates :content
end
