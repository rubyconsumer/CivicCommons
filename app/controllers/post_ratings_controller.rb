class PostRatingsController < ApplicationController
  respond_to :html, :xml, :json    
   def new 
     @question = Rating.new
     render :layout=>false
   end

   def create
     @rating = Rating.create_for_conversation(params[:rating], params[:conversation_id], current_person)
     if !@rating.errors.blank?       
       render :json=>@rating.errors.to_json and return
     end    
     @conversation = Conversation.find(params[:conversation_id])     
     render :text=>@conversation.rating
   end
end
