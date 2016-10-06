class InquiriesController < ApplicationController

  def create
    @inquiry = Inquiry.new(inquiry_params)
    @inquiry.save
    respond_to { |format| format.js }
  end

private

  def inquiry_params
    params.require(:inquiry).permit(:email, :subject, :message)
  end

end
