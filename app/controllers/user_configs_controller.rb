class UserConfigsController < ApplicationController
  def edit
    @user_config = UserConfig.find(params[:id])
  end

  def update
    @user_config = UserConfig.find(params[:id])
  end

  private

  def user_config_params
    params.expect user_config: %i[user_config_id short_distance_unit long_distance_unit weight_unit user_id ]
  end
end
