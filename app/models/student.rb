# Student model
class Student < ActiveRecord::Base
  belongs_to :country
  belongs_to :batch
  belongs_to :category
  belongs_to :nationality, class_name: 'Country'
  has_one :student_previous_data
  has_many :student_previous_subject_marks
  has_many :guardians
  has_and_belongs_to_many :fee_collection_particulars
  has_and_belongs_to_many :fee_collection_discounts
  has_many :finance_fees
  has_many :finance_fee_collections, through: :finance_fees
  has_attached_file :image
  validates_attachment_content_type :image, content_type: \
  ['image/jpg', 'image/jpeg', 'image/png', 'image/gif']

  validates :admission_no, presence: true
  validates :admission_date, presence: true
  validates :email, presence: true, format: \
  { with: /\A[a-zA-Z0-9._-]+@([a-zA-Z0-9]+\.)+[a-zA-Z]{2,4}+\z/ }

  validates :first_name, presence: true, format: \
  { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }
  validates_length_of :first_name, minimum: 1, maximum: 20

  validates :last_name, presence: true, format: \
  { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }
  validates_length_of :last_name, minimum: 1, maximum: 20

  validates :date_of_birth, presence: true
  validates :batch_id, presence: true

  validates :category_id, presence: true
  validates :nationality_id, presence: true
  validates :country_id, presence: true
  validates :middle_name, format: \
  { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }, length: \
  { in: 1..20 }, allow_blank: true
  validates :birth_place, format: \
  { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' }, length: \
  { in: 1..20 }, allow_blank: true
  validates :language, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' },
                       length: { in: 1..30 }, allow_blank: true
  validates :religion, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' },
                       length: { in: 1..20 }, allow_blank: true
  validates :address_line1, length: { in: 1..30 }, allow_blank: true
  validates :address_line2, length: { in: 1..20 }, allow_blank: true
  validates :city, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' },
                   length: { in: 1..30 }, allow_blank: true
  validates :state, format: { with: /\A[a-z A-Z]+\z/, message: 'only allows letters' },
                    length: { in: 1..30 }, allow_blank: true
  validates :pin_code, numericality: { only_integer: true },
                       length: { minimum: 6, maximum: 6 }, allow_blank: true
  validates :phone2, numericality: { only_integer: true },
                     length: { minimum: 6, maximum: 11 }, allow_blank: true
  validates :phone1, numericality: { only_integer: true },
                     length: { minimum: 6, maximum: 11 }, allow_blank: true
  after_save :create_user_account
  scope :shod, ->(id) { where(id: id).take }

  def archived_student
    student_attributes = attributes
    student_attributes['student_id'] = id
    archived_student = ArchivedStudent.create(student_attributes)
  end

  def self.set_admission_no
    date = Date.today.strftime('%Y%m%d')
    if Student.first.nil?
      'S' + date.to_s + '1'
    else
      last_id = Student.last.id.next
      'S' + date.to_s + last_id.to_s
    end
  end

  private

  def create_user_account
    user = User.new do |u|
      u.first_name = first_name
      u.last_name = last_name
      u.username = admission_no
      u.student_id = id
      u.password = admission_no
      u.role = 'Student'
      u.email = email
      u.general_setting_id =  User.current.general_setting.id
    end
    user.save
  end
end
