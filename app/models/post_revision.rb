class PostRevision < ApplicationRecord
  belongs_to :post
  scope :active, -> { where(active_revision: true) }
end
