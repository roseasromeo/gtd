class DevelopController < ApplicationController
  before_action :set_inbox, :set_user

  def develop
    if @inbox.items.empty?
      redirect_to @inbox
    end
    @step = set_step
    @item = set_item
    if @step == "delete"
      next_item_tmp = next_item(@item.id)
      if next_item_tmp != @item
        @item.destroy
        @item = next_item_tmp
        @step = "action"
      else
        @item.destroy
        redirect_to @inbox
      end
    elsif @step == "next"
      if @inbox.items.empty?

      else
        @item = next_item(@item.id)
        @step = "action"
      end
    elsif @step == "add_task"
      task_setup
      @task = Task.new(name: @item.name, description: @item.description)
    elsif @step == "added_task"
      set_project
    elsif @step == "add_single"
      @step = "add_task"
      task_setup
      set_single_step_project
      @task = Task.new(name: @item.name, description: @item.description)
    elsif @step == "start_project"
      @project = Project.new(user: @user, name: @item.name, description: @item.description)
    elsif @step == "started_project"
      set_project
    elsif @step == "choose_checklist"
      @checklists = Checklist.where(user: @user).order(name: :asc)
    elsif @step == "add_to_checklist"
      @checklist = Checklist.find(params[:checklist])
      checklist_item = @checklist.checklist_items.build(name: "#{@item.name} #{@item.description}")
    elsif @step == "make_checklist"
      @checklist = Checklist.new(user: @user, name: @item.name, description: @item.description)
    elsif @step == "waiting"
      set_waiting_checklist
      checklist_item = @checklist.checklist_items.build(name: "#{@item.name} #{@item.description}")
    elsif @step == "someday"
      set_someday_inbox
      @item.update(inbox: @someday)
    elsif @step == "add_ref_item"
      ref_item_setup
      @ref_item = RefItem.new(name: @item.name, description: @item.description)
    elsif @step == "added_ref_item"
      set_folder
    elsif @step == "add_folder"
      @folder = Folder.new(user: @user, name: @item.name, description: @item.description)
    elsif @step == "added_folder"
      set_folder
    end
  end

  private
    def set_inbox
      @inbox = Inbox.find(params[:id])
    end

    def set_someday_inbox
      @someday = Inbox.where(name: "Someday/Maybe").first
    end

    def set_user
      @user = current_user
    end

    def set_item
      if params[:item] != nil
        item = Item.find(params[:item])
      end
      if params[:item] == nil || item.inbox != @inbox
        item = @inbox.items.order(created_at: :desc).first
      end
      item
    end

    def set_step
      step = "action"
      if params[:next_step] != nil
        step = params[:next_step]
      end
      step
    end

    def next_item(id)
      @inbox.items.where("id > ?", id).order(id: :asc).first ||   @inbox.items.first
    end

    def prev_item(id)
      @inbox.items.where("id < ?", id).order(id: :desc).first ||   @inbox.items.last
    end

    def set_project
      if params.has_key?(:project_id)
        @project = Project.find(params[:project_id])
        if @project.user != current_user
          @project = @default_project
        end
      elsif params[:task] != nil && params[:task].has_key?(:project_id)
        @project = Project.find(params[:task][:project_id])
        if @project.user != current_user
          @project = @default_project
        end
      else
        if @task == nil
          @project = @default_project
        else
          @project = @task.project
        end
        if @project == nil
          @project = @default_project
        end
      end
    end

    def set_default_project
      @default_project = Project.where(user: @user, name: "Unassigned").first
    end

    def set_location
      if params.has_key?(:location_id)
        @location = Location.find(params[:location_id])
        if @location.user != current_user
          @location = @default_location
        end
      elsif params[:task] != nil && params[:task].has_key?(:location_id)
        @location = Location.find(params[:task][:location_id])
        if @location.user != current_user
          @location = @default_location
        end
      else
        if @task == nil
          @location = @default_location
        else
          @location = @task.location
        end
        if @location == nil
          @location = @default_location
        end
      end
    end

    def set_default_location
      @default_location = Location.where(user: @user, name: "Anywhere").first
    end

    def time_collection
      @time_collection = Hash.new
      Task.time_names.each do |k,v|
        @time_collection[k] = v
      end
    end

    def energy_collection
      @energy_collection = { low: 0, medium: 1, high: 2 }
    end

    def projects
      @projects = Project.where(user: @user)
    end

    def locations
      @locations = Location.where(user: @user)
    end

    def task_setup
      set_default_project
      set_default_location
      time_collection
      energy_collection
      projects
      locations
      set_project
      set_location
    end

    def set_single_step_project
      if Project.where(user: @user, name: "Single Step").empty?
        @project = @default_project
      else
        @project = Project.where(user: @user, name: "Single Step").first
      end
    end

    def set_waiting_checklist
      @checklist = Checklist.where(user: @user, name: "Waiting On").first
    end

    def set_default_folder
      @default_folder = Folder.where(user: @user, name: "General Reference").first
    end

    def folders
      @folders = Folder.where(user: @user)
    end

    def set_folder
      if params.has_key?(:folder_id)
        @folder = Folder.find(params[:folder_id])
        if @folder.user != current_user
          @folder = @default_folder
        end
      else
        if @task == nil
          @folder = @default_folder
        else
          @folder = @ref_item.folder
        end
        if @folder == nil
          @folder = @default_folder
        end
      end
    end

    def ref_item_setup
      set_default_folder
      folders
      set_folder
    end
end
