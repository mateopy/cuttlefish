class AppsController < ApplicationController
  def index
    @apps = App.all
  end

  def show
    @app = App.find(params[:id])
  end

  def new
    @app = App.new
  end

  def create
    @app = current_admin.team.apps.build(app_parameters)
    if @app.save
      flash[:notice] = "App #{@app.name} successfully created"
      redirect_to @app
    else
      render :new
    end
  end

  def destroy
    @app = App.find(params[:id])
    flash[:notice] = "App #{@app.name} successfully removed"
    @app.destroy
    redirect_to apps_path
  end

  def edit
    @app = App.find(params[:id])
  end

  def update
    @app = App.find(params[:id])
    if @app.update_attributes(app_parameters)
      flash[:notice] = "App #{@app.name} successfully updated"
      redirect_to @app
    else
      render :edit
    end
  end

  def new_password
    app = App.find(params[:id])
    app.new_password!
    redirect_to app
  end

  def lock_password
    app = App.find(params[:id])
    app.update_attribute(:smtp_password_locked, true)
    redirect_to app
  end

  def dkim
    @app = App.find(params[:id])
  end

  def toggle_dkim
    app = App.find(params[:id])
    app.update_attribute(:dkim_enabled, !app.dkim_enabled)
    redirect_to app
  end

  private

  def app_parameters
    params.require(:app).permit(:name, :url, :custom_tracking_domain, :open_tracking_enabled,
      :click_tracking_enabled, :from_domain)
  end
end
