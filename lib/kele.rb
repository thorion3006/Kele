require 'httparty'

class Kele
  include HTTParty

  def initialize(username, password)
    base_uri = 'https://www.bloc.io/api/v1'

    values = {
      email: username,
      password: password
    }

    @auth_token = Kele.post(base_uri + '/sessions', body: values)
  end
end
