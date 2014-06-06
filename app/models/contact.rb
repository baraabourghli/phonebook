class Contact < ActiveRecord::Base

  validates :full_name, :number, presence: true
  validates :number, uniqueness: { case_sensitive: false }

end
