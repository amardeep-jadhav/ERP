class GradingLevel < ActiveRecord::Base

	belongs_to :batch

	validates :name, presence: true ,format: { with: /\A[a-zA-Z]+\z/,message: "only allows letters" }
	validates_length_of :name,:minimum => 1,:maximum =>15
	validates :min_score, presence: true ,numericality: { only_integer: true }


end
