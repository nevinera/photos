module ApplicationHelper
  def gallery_path(g)
    "/galleries/#{g.secret}"
  end
end
