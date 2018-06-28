# frozen_string_literal: true

class Profiles::AffiliationsController < ApplicationController
  before_action :authenticate_user!
  before_action :find_and_authorize, only: [:show, :edit, :update, :destroy]

  def index
    @affiliations = policy_scope(Affiliation).order(:iid).page(params[:page])
  end

  def new
    @affiliation = Affiliation.new(user: current_user)
    authorize(@affiliation)
  end

  def create
    @affiliation = Affiliation.new(permitted_attributes(Affiliation).
                                   merge(user: current_user))
    authorize(@affiliation)

    if @affiliation.save
      redirect_to profile_affiliation_path(@affiliation),
                  notice: "New affiliation created sucessfully"
    else
      render :new, status: :bad_request
    end
  end

  def edit
  end

  def update
    if @affiliation.update_attributes(permitted_attributes(@affiliation))
      redirect_to profile_affiliation_path(@affiliation),
                  notice: "Affiliation updated correctly"
    else
      render :edit, status: :bad_request
    end
  end

  def destroy
    @affiliation.destroy
    redirect_to profile_affiliations_path,
                notice: "Affiliation destroyed"
  end

  private

    def find_and_authorize
      @affiliation = Affiliation.find_by(iid: params[:id])
      authorize(@affiliation)
    end
end
