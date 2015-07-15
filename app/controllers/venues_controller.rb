class VenuesController < ApplicationController
  def show
    @venue = Venue.find_by(id: params[:id])
    @items = Item.active.not_in_cart(session[:cart]).joins(:event).where(events: {venue_id: @venue.id}).paginate(:page => params[:page], :per_page => 10)
    # @events = @items.map(&:event).uniq
    @events = @venue.events.paginate(:page => params[:page], :per_page => 10)
  end
end
