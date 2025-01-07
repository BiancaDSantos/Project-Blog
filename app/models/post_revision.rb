class PostRevision < ApplicationRecord
  belongs_to :post
  has_many :tag_posts
  has_many :tags, -> { merge(TagPost.active) }, through: :tag_posts

  scope :active, -> { where(active_revision: true) }

  validates :title, presence: { message: "O campo título deve ser preenchido" },
            length: { maximum: 300, message: "O título não pode ter mais de 300 caracteres." }
end
