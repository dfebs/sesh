class UserConfigsController < ApplicationController
  rate_limit to: 100, within: 1.minute

  def edit
    @user_config = UserConfig.find(params[:id])
  end

  def update
    @user_config = UserConfig.find(params[:id])

    if @user_config.update(user_config_params)
      redirect_back_or_to root_path, notice: "Configuration saved!"
    else
      render :edit, status: :unprocessable_entity, alert: "Could not edit configuration"
    end
  end

  private

  def user_config_params
    params.expect user_config: %i[user_config_id short_distance_unit long_distance_unit weight_unit user_id ]
  end
end
