class Comment < ApplicationRecord
  belongs_to :author, optional: true
  belongs_to :post

  validates :content, presence: { message: "O conteúdo do comentário é obrigatório." },
            length: { maximum: 300, message: "O conteúdo não pode ter mais de 300 caracteres." }
end
