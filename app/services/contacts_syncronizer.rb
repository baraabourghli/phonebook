class ContactsSyncronizer
  
  def self.sync(contacts)
    
    contacts_numbers = contacts.map { |c| c.number }
    
    # handle deleted contacts
    Contact.where("number NOT IN (?)", contacts_numbers).each do |contact|
      contact.delete
    end

    # handle updated contacts
    Contact.where("number IN (?)", contacts_numbers).each do |contact|
      contact.full_name =  contacts.detect { |c| c.number == contact.number }.full_name
      contact.save
    end

    # handle new records
    contacts = contacts.reject { |c| Contact.where(number: c.number).first.present? }
    contacts.each do |contact| 
      Contact.create!(full_name: contact.full_name, number: contact.number)
    end

  end

end