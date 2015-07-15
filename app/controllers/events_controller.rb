class EventsController < ApplicationController

  def index
    @items = Item.active.not_in_cart(session[:cart]).paginate(:page => params[:page], :per_page => 10)
    # @events ||= @items.map(&:event).uniq
    @category = Category.find_by(name: params[:category])
    if @category
      @events = Event.where(category: @category).paginate(:page => params[:page], :per_page => 10)
    else
      @events = Event.all.paginate(:page => params[:page], :per_page => 10)
    end
  end

  # def index
  #   @items = Item.active.not_in_cart(session[:cart]).paginate(:page => params[:page], :per_page => 10)
  #   # @items = Item.active.not_in_cart(session[:cart])
  #   @events = @items.map(&:event).uniq
  #   @events = @events.select { |event| event.category.name == params[:category] } if params[:category]
  # end

  def show
    @event = Event.find_by(id: params[:id])
    @items = @event.items.active.not_in_cart(session[:cart]).paginate(:page => params[:page], :per_page => 10)
  end

  def random
    event = Event.find(rand(1..Event.count))
    redirect_to event
  end

  # def random
  #   if Event.count > 0
  #     offset = rand(Event.active.count)
  #     event = Event.active.offset(offset).first
  #     redirect_to event
  #   else
  #     redirect_to root_path
  #   end
  # end
  
end
