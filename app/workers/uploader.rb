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

    num = 1
    # total = Contact.where("number NOT IN (?)", contacts_numbers).count + Contact.where("number IN (?)", contacts_numbers).count + (Contact.all.count - Contact.where("number IN (?)", contacts_numbers).count)
    at(num, 100, "test")

    ContactsSyncronizer.sync(contacts)
  end
end