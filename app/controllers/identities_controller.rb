class IdentitiesController < ApplicationController

  before_action :authenticate_user!
  before_action :load_identity
  before_action :authorize_user!

  def destroy
    flash[:notice] = "You've succesfully disconnected your #{@identity.provider.capitalize} account."
    @identity.destroy
    current_user.update_columns(avatar_option: 'upload')
    redirect_to edit_user_registration_path(setting: 'account')
  end

private

  def load_identity
    @identity = Identity.find(params[:id])
  end

  def authorize_user!
    unless @identity.user == current_user
      flash[:danger] = 'You do not have access to that area or operation.'
      redirect_to edit_user_registration_path(setting: 'account')
    end
  end

end
