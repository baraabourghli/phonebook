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

    ContactsSyncronizer.sync(contacts)
  end
end