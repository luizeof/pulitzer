class Pulitzer::JustificationStylesController < Pulitzer::ApplicationController
  before_filter :get_justification_style, only: [:show, :edit, :update, :destroy]

  def new
    @justification_style = Pulitzer::JustificationStyle.new(justification_style_params)
    @post_type = @justification_style.post_type
    render partial: 'new', locals: {justification_style: @justification_style}
  end

  def create
    @justification_style = Pulitzer::JustificationStyle.create(justification_style_params)
    if @justification_style.errors.empty?
      render partial: 'show_wrapper', locals: {justification_style: @justification_style}
    else
      @post_type = @justification_style.post_type
      render partial: 'new', locals: {justification_style: @justification_style}
    end
  end

  def show
    render partial: 'show', locals: {justification_style: @justification_style}
  end

  def edit
    render partial: 'form', locals: {justification_style: @justification_style}
  end

  def update
    @justification_style.update_attributes(justification_style_params)
    if @justification_style.errors.empty?
      render partial: 'show', locals: {justification_style: @justification_style}
    else
      render partial: 'form', locals: {justification_style: @justification_style}, status: 409
    end
  end

  def destroy
    @justification_style.destroy
    head :ok
  end

  protected

  def get_justification_style
    @justification_style = Pulitzer::JustificationStyle.find(params[:id])
  end

  def justification_style_params
    params[:justification_style].permit!
  end

end
