require 'spec_helper'
require 'pry'

describe ContactsSyncronizer do

  before :each do
    100.times { create(:contact) }
  end

  describe ".sync" do

    it "deletes contacts that have been removed" do
      contacts = Contact.all.to_a
      contacts.shift
      ContactsSyncronizer.sync(contacts)
      expect(Contact.all).to have(99).item
    end

    it "updates contacts that have been updated" do
      contacts = Contact.all.to_a
      contacts[0].full_name = 'test name'
      ContactsSyncronizer.sync(contacts)
      expect(Contact.where(:full_name => 'test name')).to have(1).item
    end
    
    it "adds contacts that have been added" do
      contacts = Contact.all.to_a
      contacts << Contact.new(full_name: 'new contact', number: "#{Time.now.to_i}")
      ContactsSyncronizer.sync(contacts)
      expect(Contact.where(:full_name => 'new contact')).to have(1).item
    end

  end

end
