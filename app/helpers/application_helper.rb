# frozen_string_literal: true

module ApplicationHelper
  def json_pretty_generate(json)
    JSON.pretty_generate(JSON.parse(json))
  end

  def class_active(*controllers)
    controllers.include?(params[:controller]) ? 'class="active"'.html_safe : ''
  end

  def bootstrap_class_for(flash_type)
    case flash_type.to_sym
      when :success
        "alert-success" # Green
      when :error
        "alert-danger" # Red
      when :alert
        "alert-warning" # Yellow
      when :notice
        "alert-info" # Blue
      else
        flash_type.to_s
    end
  end

end
