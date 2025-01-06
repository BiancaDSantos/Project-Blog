class Author < ApplicationRecord

  validates :name, presence: { message: "Este campo é obrigatório." },
            length: { minimum: 1, maximum: 100, message: "O tamanho do nome deve ser entre 1 e 100 caracteres." }
  validates :senha, presence: { message: "Este campo é obrigatório." },
            length: { minimum: 8, maximum: 12, message: "A senha deve ter entre 8 e 12 caracteres." }
  validates :email, presence: { message: "Este campo é obrigatório." },
            uniqueness: { message: "Uma conta já foi cadastrada com esse e-mail." },
            length: { maximum: 150, message: "Verifique o tamanho do email." },
            format: { with: URI::MailTo::EMAIL_REGEXP, message: "Verifique o formato do email." }
end
