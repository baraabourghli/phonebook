class Uploader
  include Resque::Plugins::Status
  @queue = :uploader_queue
  
  def perform
    contacts = []
    
    file = options['file'].split(/\n/)

    file.each do |line|
      full_name, number = line.split(/\t/)
      contacts << Contact.new(full_name: full_name, number: number)
    end
    contacts_numbers = contacts.map { |c| c.number }

    num = 1
    # total = Contact.where("number NOT IN (?)", contacts_numbers).count + Contact.where("number IN (?)", contacts_numbers).count + (Contact.all.count - Contact.where("number IN (?)", contacts_numbers).count)
    at(num, 100, "test")
    
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