class Tag < ApplicationRecord
  validates :name, presence: { message: "O nome da tag deve ser preenchida." },
            length: { minimum: 1, maximum: 100, message: "O tamanho da tag deve ser entre 1 e 60 caracteres." },
            format: { with: /\A[^0-9]*\z/, message: "O nome da tag não pode conter números." }
end
