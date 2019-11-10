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
      @item.destroy
      @item = next_item_tmp
      @step = "action"
    elsif @step == "next"
      @item = next_item(@item.id)
      @step = "action"
    end
  end

  private
    def set_inbox
      @inbox = Inbox.find(params[:id])
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
end
