class GalleriesController < ApplicationController
  def index
    authenticate_admin!
    @galleries = Gallery.order('created_at desc')
  end

  def show
    @gallery = Gallery.find_by_secret(params[:secret])

    # here we will authenticate unless the thing is 'confirmed' for viewing
    # by the customers

    unless @gallery
      redirect_to :root, :notice => "That gallery was not found"
    end
  end

  def new
    authenticate_admin!
    @gallery = Gallery.new :secret => Gallery.random_secret
  end

  def create
    authenticate_admin!
    gal = params.require(:gallery).permit!
    @gallery = Gallery.new gal

    if @gallery.save
      @gallery.move_to_working_dir!
      @gallery.queue_import!

      redirect_to galleries_path, :notice => "That gallery has been created"
    else
      render :new
    end
  end
end
