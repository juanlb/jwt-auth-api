class ApplicationController < ActionController::Base
    before_action :authenticate_admin! 

    def set_fullpage
        @fullpage = true
    end
end
