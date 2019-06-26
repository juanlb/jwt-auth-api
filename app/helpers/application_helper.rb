# frozen_string_literal: true

module ApplicationHelper
  def json_pretty_generate(json)
    JSON.pretty_generate(JSON.parse(json))
  end
end
