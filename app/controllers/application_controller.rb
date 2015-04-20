class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
#  helper_method :get_collection
#  helper_method :get_collection_id
  helper_method :flash_class



  def get_collection
    if  session[:collection_id]
       @collection =  Collection.friendly.find(session[:collection_id])
      session[:collection_id] = @collection[:id]
    else
      @collection =  Collection.friendly.find(params[:collection_id])
      session[:collection_id] = @collection[:id]
    end
  end





end
