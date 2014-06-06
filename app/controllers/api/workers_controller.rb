class Api::WorkersController < ApiController
  
  def status
    @status = OpenStruct.new(Resque::Plugins::Status::Hash.get(params[:worker_id]))
  end 

end