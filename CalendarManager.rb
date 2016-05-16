require 'google/apis/calendar_v3'
require 'googleauth'
require 'googleauth/stores/file_token_store'
require './EventCompare.rb'

require 'fileutils'
require 'pp'

OOB_URI = 'urn:ietf:wg:oauth:2.0:oob'
APPLICATION_NAME = 'Google Calendar API Ruby Quickstart'
CLIENT_SECRETS_PATH = 'client_secret.json'
CREDENTIALS_PATH = File.join(Dir.home, '.credentials',
                             "calendar-ruby-quickstart.yaml")
SCOPE = Google::Apis::CalendarV3::AUTH_CALENDAR

class CalendarManager

  ##
  # Ensure valid credentials, either by restoring from the saved credentials
  # files or intitiating an OAuth2 authorization. If authorization is required,
  # the user's default browser will be launched to approve the request.
  #
  # @return [Google::Auth::UserRefreshCredentials] OAuth2 credentials
  def authorize
    FileUtils.mkdir_p(File.dirname(CREDENTIALS_PATH))

    client_id = Google::Auth::ClientId.from_file(CLIENT_SECRETS_PATH)
    token_store = Google::Auth::Stores::FileTokenStore.new(file: CREDENTIALS_PATH)
    authorizer = Google::Auth::UserAuthorizer.new(
      client_id, SCOPE, token_store)
    user_id = 'default'
    credentials = authorizer.get_credentials(user_id)
    if credentials.nil?
      url = authorizer.get_authorization_url(
        base_url: OOB_URI)
      puts "Open the following URL in the browser and enter the " +
        "resulting code after authorization"
      puts url
      code = gets
      credentials = authorizer.get_and_store_credentials_from_code(
        user_id: user_id, code: code, base_url: OOB_URI)
    end
    credentials
  end


  def initialize
    # Initialize the API
    @service = Google::Apis::CalendarV3::CalendarService.new
    @service.client_options.application_name = APPLICATION_NAME
    @service.authorization = authorize
  end

  def GetCalendarList


    # Fetch the next 10 events for the user
    calendar_id = 'primary'
    response = @service.list_events(calendar_id,
                                    #max_results: 10,
                                    single_events: true,
                                    order_by: 'startTime',
                                    time_min: Time.now.iso8601)

    puts "Upcoming events:"
    puts "No upcoming events found" if response.items.empty?
    event_list = []
    response.items.each do |event|
      start_time = event.start.date_time.to_time
      end_time   = event.end.date_time.to_time
      puts "- #{event.summary} (#{start_time} - #{end_time}) @ #{event.location}"
      event_list << Event.new(start_time, start_time, end_time, event.summary, event.location)

    end
    event_list
  end

  def addEvent
    event = Google::Apis::CalendarV3::Event.new({
      summary: 'テストイベントです',
      location: '中原小学校',
      description: 'A chance to hear more about Google\'s developer products.',
      start: {
        date_time: '2015-05-28T09:00:00-07:00',
        time_zone: 'America/Los_Angeles',
      },
      end: {
        date_time: '2015-05-28T17:00:00-07:00',
        time_zone: 'America/Los_Angeles',
      }
    })

    result = @service.insert_event('primary', event)
    puts "Event created: #{result.html_link}"
  end
end

cm = CalendarManager.new
pp cm.GetCalendarList
#cm.addEvent
