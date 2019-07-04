module JsonConcern
    extend ActiveSupport::Concern
  
    def clean_malformed_json(malformed_json)
        malformed_json.gsub(/\s+/, ' ').gsub('"', "'").strip
      end

  end