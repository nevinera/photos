class AdminsController < ApplicationController
  before_filter :authenticate_admin!

  def edit
    @admin = Admin.find params[:id]
  end

  def update
    @admin = Admin.find params[:id]
    unless @admin == current_admin
      redirect_to root_path, :notice => "You can't edit somebody else's password!"
    end

    attrs = params.
      require(:admin).
      permit(:email, :password, :password_confirmation)

    if @admin.update_attributes(attrs)
      redirect_to root_path, :notice => "Your changes were successful"
    else
      render :edit
    end
  end
end
