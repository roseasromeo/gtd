class ApplicationController < ActionController::Base

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def current_user
    @_current_user ||=User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user != nil
  end

  helper_method :current_user, :admin_user?

  private
    def sort_column
      if Task.column_names.include?(params[:sort])
        params[:sort]
      # elsif Project.names.include?(params[:sort])
      #   params[:sort]
      # elsif Location.names.include?(params[:sort])
      #   params[:sort]
      # elsif Task.names.include?(params[:sort])
      #   params[:sort]
      else
        "name"
      end
    end

    def sort_direction
      %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
    end

    def sort_tasks(tasks, column, direction, pledges)
      if Task.column_names.include?(column)
        tasks = tasks.order(column + " " + direction)
      # elsif Tags.names.include?(column)
      #   if direction == "asc"
      #     characters = characters.sort_by{|character| pledge_array(character, pledges, column)}
      #   else
      #     characters = characters.sort_by{|character| -pledge_array(character, pledges, column)}
      #   end
      else
        tasks = tasks.order("name" + " " + "asc")
      end
      tasks
    end


end
