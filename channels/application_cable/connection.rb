module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      self.current_user = find_verified_user
    end

    private
    def find_verified_user
      begin

        # rails5.1 change the method of find_verified_user,can't use self.
        # https://github.com/rails/rails/commit/91fa2b71c3fecb26a1dc7836874478f12e6d7a02#diff-e7a49345fe344d173cbcd874c21a1a61
        header_array = request.headers[:HTTP_SEC_WEBSOCKET_PROTOCOL].split(',')
        token = header_array[header_array.length - 1]
        user_id = JsonWebToken.decode(token)[:user_id].to_i
        if current_user = User.find(user_id)
          current_user
        else
          reject_unauthorized_connection
        end
      rescue
        reject_unauthorized_connection
      end
    end
  end
end
