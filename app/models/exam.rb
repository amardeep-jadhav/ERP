class Exam < ActiveRecord::Base
	belongs_to :exam_group
	has_many :exam_scores
end