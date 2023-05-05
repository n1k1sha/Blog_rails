class Article < ApplicationRecord

    has_many :comments, dependent: :destroy

    belongs_to :user

    has_one_attached :photo

    validates :title, presence: true
    validates :body, presence: true, length: { minimum: 10 }
    
end
