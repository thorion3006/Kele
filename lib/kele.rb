require 'httparty'
require 'json'
require './lib/roadmap'

class Kele
  include HTTParty
  include JSON
  include Roadmap
  base_uri 'https://www.bloc.io/api/v1'

  def initialize(username, password)
    values = {
      email: username,
      password: password
    }

    response = self.class.post('/sessions', body: values)
    @auth_token = response["auth_token"]
  end

  def get_me
    response = self.class.get('/users/me', headers: { authorization: @auth_token })
    JSON.parse(response.body)
  end

  def get_mentor_availability(mentor_id)
    response = self.class.get("/mentors/#{mentor_id}/student_availability", headers: { authorization: @auth_token })
    JSON.parse(response.body)
  end

  def get_messages(page = nil)
    values = {
      page: page,
      headers: { authorization: @auth_token }
    }
    response = self.class.get('/message_threads', values)
    JSON.parse(response.body)
  end

  def create_message(options = {})
    values = {
      headers: { authorization: @auth_token },
      body: {
        sender: options[:sender],
        recipient_id: options[:recipient_id],
        token: options[:token],
        subject: options[:subject],
        'stripped-text' => options["stripped-text"]
      }
    }
    self.class.post('/messages', values)
  end

  def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
    values = {
      headers: { authorization: @auth_token },
      body: {
        enrollment_id: 21294,
        checkpoint_id: checkpoint_id,
        assignment_branch: assignment_branch,
        assignment_commit_link: assignment_commit_link,
        comment: comment
      }
    }
    self.class.post('/checkpoint_submissions', values)
  end
end
