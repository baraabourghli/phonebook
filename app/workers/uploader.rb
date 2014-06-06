class Uploader
  include Resque::Plugins::Status
  @queue = :uploader_queue
  
  def perform
    contacts = []
    
    file = options['file'].split(/\n/)
    num = 1
    at(num, 100,"test")
    sleep(10)
    file.each do |line|
      full_name, number = line.split(/\t/)
      contacts << Contact.new(full_name: full_name, number: number)
      num+=1
      at(num, 100,"test")
    end
    contacts_numbers = contacts.map { |c| c.number }
    sleep(10)
    
    # handle deleted contacts
    Contact.where("number NOT IN (?)", contacts_numbers).each do |contact|
      contact.delete
      num+=1
      at(num, 100,"test")

    end
    sleep(10)

    # handle updated contacts
    Contact.where("number IN (?)", contacts_numbers).each do |contact|
      contact.full_name =  contacts.detect { |c| c.number == contact.number }.full_name
      contact.save
      num+=1
      at(num, 100,"test")

    end

    sleep(10)
    # handle new records
    contacts = contacts.reject { |c| Contact.where(number: c.number).first.present? }
    contacts.each do |contact| 
      Contact.create!(full_name: contact.full_name, number: contact.number)
      num+=1
      at(num, 100,"test")

    end
  end
end