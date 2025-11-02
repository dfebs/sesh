class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def render_flash_stream(status = :ok)
    render turbo_stream: turbo_stream.replace("flash", partial: "layouts/flash", locals: { flash: flash }), status: status
  end
end
