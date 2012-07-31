# coding: utf-8
class AssistancesController < ApplicationController
  layout 'assistance'
  before_filter :require_login

  def index
  end

  def show
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    @assist_helpers = @assist.assistance_helpers.includes(:user).limit(20)
    @comments = @assist.comments.includes(:user)
  end

  def create
    @user = current_user
    assist = @user.assistances.build(:content => params[:content])
    respond_to do |format|
      format.js { render :text => { :success => assist.save }.to_json }
    end
  end

  def joined
    @assist = Assistance.where(:_id => params[:id]).first
    @user = @assist.user
    @helpers = @assist.assistance_helpers.includes(:user)
  end

  def join
    assistance_helper = current_user.assistance_helpers.build(:assistance_id => params[:id], :content => params[:content])
    respond_to do |format|
      format.js { render :text => { :success => assistance_helper.save }.to_json }
    end
  end

  def mark_as_helpful
    assistance_helper = AssistanceHelper.where(:_id => params[:id]).first
    assistance_helper.update_attribute(:helpful, true)
    render :nothing => true
  end
  
end