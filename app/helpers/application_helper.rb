# frozen_string_literal: true

module ApplicationHelper

  def json_pretty_generate(json)
    JSON.pretty_generate(JSON.parse(json))
  end

  def class_active(*controllers)
    controllers.include?(params[:controller]) ? 'active'.html_safe : ''
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

  def enabled_icon(enabled)
    if enabled
      icon('far', 'check-square')
    else
      icon('far', 'square')
    end
  end

  def permission_state(allowed_app)
    if allowed_app.permissions_valid?
      valid_icon
    else
      invalid_icon
    end
  end

  def show_permissions_state(permissions_state_hash)
    perm = permissions_state_hash.select {|k,v| v > 0}.map{|k,v| "#{v} #{icons[k]}"}
    perm.empty? ? '0' : perm.join(' - ').html_safe
  end

  private

  def valid_icon
    icons[:valid]
  end

  def invalid_icon
    icons[:invalid]
  end

  def icons
    {
      valid: (icon('fas', 'check', class: 'fa-green')),
      invalid: (icon('fas', 'times', class: 'fa-red'))
    }
  end
  
  

end
