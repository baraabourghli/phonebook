class Api::ContactsController < ApiController
  before_action :set_contact, only: [:show, :update, :destroy]

  def index
    @contacts = Contact.all.order(:number)
  end

  def show
  end

  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        format.json { render json: "ok", status: :created }
      else
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @contact.update(contact_params)
      head :no_content
    else
      render json: { api_error: @contact.errors, status: :unprocessable_entity }
    end
  end

  def destroy
    if @contact.destroy
      head :no_content
    else
      render json: { api_error: @contact.errors, status: :unprocessable_entity }
    end
  end
  
  def download
    file_name = 'phonebook.txt'
    file = File.open("public/data/#{file_name}", "w")
    Contact.all.find_each do |contact|
      file.write "#{contact.full_name}\t#{contact.number}\n"
    end
    file.close
    send_file "public/data/#{file_name}", :type => :text
  end 

  def upload
    job_id = Uploader.create(:file => params[:phonebook].read)

    render json: { job_id: job_id }
  end

  private

  def set_contact
    @contact = Contact.find(params[:id])
  end

  def contact_params
    params.require(:contact).permit(:full_name, :number)
  end

end