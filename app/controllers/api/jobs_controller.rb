class Api::JobsController < ApiController
  
  def status
    @status = OpenStruct.new(Resque::Plugins::Status::Hash.get(params[:worker_id]))
  end 

end