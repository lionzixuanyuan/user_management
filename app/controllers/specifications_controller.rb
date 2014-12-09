class SpecificationsController < ApplicationController
  before_action :set_specification, only: [:show, :edit, :update, :destroy]

  before_action :require_log_in, only: [:new, :edit]

  # GET /specifications
  # GET /specifications.json
  def index
    @specifications = Specification.all
    render layout: "with_left_nav"
  end

  # GET /specifications/1
  # GET /specifications/1.json
  def show
    render layout: "with_left_nav"
  end

  # GET /specifications/new
  def new
    @specification = Specification.new
    render layout: "with_left_nav"
  end

  # GET /specifications/1/edit
  def edit
    render layout: "with_left_nav"
  end

  # POST /specifications
  # POST /specifications.json
  def create
    @specification = Specification.new(specification_params)
    @specification.creater = @current_user

    respond_to do |format|
      if @specification.save
        format.html { redirect_to @specification, notice: 'Specification was successfully created.' }
        format.json { render action: 'show', status: :created, location: @specification }
      else
        format.html { render action: 'new', layout: "with_left_nav" }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specifications/1
  # PATCH/PUT /specifications/1.json
  def update
    respond_to do |format|
      if @specification.update(specification_params)
        format.html { redirect_to @specification, notice: 'Specification was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit', layout: "with_left_nav" }
        format.json { render json: @specification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specifications/1
  # DELETE /specifications/1.json
  def destroy
    @specification.destroy
    respond_to do |format|
      format.html { redirect_to specifications_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specification
      @specification = Specification.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specification_params
      params.require(:specification).permit(:creater_id, :brand, :model, :pdf)
    end
end
