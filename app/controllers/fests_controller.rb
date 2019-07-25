class FestsController < ApplicationController
  before_action :set_fest, only: [:show, :edit, :update]

  # GET /fests
  def index
    @fests = Fest.all
  end

  # GET /fests/1
  def show
    
  end

  # GET /fests/new
  def new
    @fest = Fest.new
  end

  # GET /fests/1/edit
  def edit

  end

  # POST /fests
  def create
    @fest = Fest.new(fest_params)

    if @fest.save
      redirect_to @fest, notice: 'Fest was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /fests/1
  def update
    if @fest.update(fest_params)
      redirect_to @fest, notice: 'Fest was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_fest
      @fest = Fest.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def fest_params
      case action_name
      when "create"
        params.fetch(:fest, {}).permit(:fest_name , :fest_status , :selection_a , :selection_b)
      when "update"
        params.fetch(:fest, {}).permit(:fest_name , :fest_status , :selection_a , :selection_b , :fest_result)
      end
    end
end
