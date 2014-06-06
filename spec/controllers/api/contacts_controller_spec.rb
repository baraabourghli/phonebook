require 'spec_helper'
require 'pry'

describe Api::ContactsController do
  render_views  # force render view for rabl output

  # Force json on each request
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/json'
    100.times { create(:contact) }
  end

  describe "GET index" do

    it "outputs in proper JSON format" do
      get :index
      expect(!!JSON.parse(response.body)).to be_true
    end
    
    it "outputs all contacts" do
      get :index
      expect(JSON.parse(response.body)).to have(100).item
    end
  end

end
