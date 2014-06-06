class Contact < ActiveRecord::Base

  validates_presence_of :full_name, :number
  validates_uniqeness_of :number

end
