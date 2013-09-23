class Admin::DecksController < Admin::MainController
  def index
    @decks = User::Deck.all
  end

  def show
    @deck = User::Deck.find(params[:id])
    @cards = ::Card.find(@deck.cards)
    @cards = @deck.cards.collect {|i| ::Card.find(i) }
    @hq = ::Card.find(@deck.hq)
  end

  def new
    @deck = User::Deck.new
    @cards = ::Card.joins(:type).where("types.name = 'Unit'")
    @headquarters = ::Card.joins(:type).where("types.name = 'Headquarters'").limit(4)
  end

  def create
    cards = Hash.new
    cards = JSON.parse(params[:selected])

    hq = params[:hq]
    name = params[:name]

    deck = User::Deck.new(:name => name, :hq => hq, :cards => cards, :user_id => 0)

    response = Hash.new
    response["result"] = false
    response["valid"] = "/admin/decks"

    deck.validate_user = false

    if deck.save
      response["result"] = true

      respond_to do |format|
        format.json { render :json => response }
      end
    else
      respond_to do |format|
        format.json { render :json => response }
      end
    end
  end

  def edit
    @deck = User::Deck.find_by_id(params[:id])

    #available cards
    @cards = ::Card.joins(:type).where("types.name = 'Unit'")
    @headquarters = ::Card.joins(:type).where("types.name = 'Headquarters'").limit(4)

    #existing cards in deck
    @selected = ::Card.find(@deck.cards)
    @selected = @deck.cards.collect {|i| ::Card.find(i) }
    @hq = ::Card.find(@deck.hq)
  end

  def update
    cards = Hash.new
    cards = JSON.parse(params[:selected])

    hq = params[:hq]
    name = params[:name]

    @deck = User::Deck.find_by_id(params[:id])

    response = Hash.new
    response["result"] = false
    response["valid"] = "/admin/decks"

    if @deck.update_attributes(:name => name, :hq => hq, :cards => cards, :user_id => 0)
        response["result"] = true

        respond_to do |format|
          format.json { render :json => response }
        end
      else
        respond_to do |format|
          format.json { render :json => response }
        end
      end
  end

  def destroy
    @deck = User::Deck.find_by_id(params[:id])
    
    if @deck.destroy
      redirect_to(admin_decks_path, notice: "A deck was deleted")
    else
      redirect_to(admin_decks_path, notice: "An error occured, the deletion was not successful")
    end
  end
end
