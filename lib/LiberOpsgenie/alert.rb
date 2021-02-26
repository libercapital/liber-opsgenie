# frozen_string_literal: true

module LiberOpsgenie
  # from https://docs.opsgenie.com/docs/alert-api#create-alert
  class Alert
    P1 = 'P1'
    P2 = 'P2'
    P3 = 'P3'
    P4 = 'P4'
    P5 = 'P5'

    # Message of the alert
    # 130 characters
    def message=(new_essage)
      @message = new_essage[0..130]
    end

    # Client-defined identifier of the alert, that is also the key element of Alert De-Duplication.
    # 512 characters
    def alias=(new_alias)
      @alias = new_alias[0..512]
    end

    # Description field of the alert that is generally used to provide a detailed information about the alert.
    # 15000 characters
    def description=(new_description)
      @description = new_description[0..15_000]
    end

    # Teams, users, escalations and schedules that the alert will be routed to send notifications.
    # type field is mandatory for each item, where possible values are team, user, escalation and schedule.
    # If the API Key belongs to a team integration, this field will be overwritten with the owner team.
    # Either id or name of each responder should be provided.
    # 50 teams, users, escalations or schedules
    def responders=(new_responders)
      raise 'Responders must be an array!' unless new_responders.is_a?(Array)
      raise 'Responders must be up to 50 items!' unless new_responders.size < 50
      raise 'Responders items must include type!' unless new_responders.reject { |v| v.include?(:type) }.empty?
      raise 'Responders items type must be one of: team, user, escalation or schedule!' unless new_responders.reject { |v| %w[team user escalation schedule].include?(v[:type]) }.empty?
      raise 'Responders items must include id, name or username!' unless new_responders.reject { |v| v.include?(:id) || v.include?(:name) || v.include?(:username) }.empty?

      @responders = new_responders unless new_responders.empty?
    end

    # Teams and users that the alert will become visible to without sending any notification.type field is mandatory
    # for each item, where possible values are team and user. In addition to the type field, either id or name should
    # be given for teams and either id or username should be given for users. Please note: that alert will be visible
    # to the teams that are specified withinresponders field by default, so there is no need to re-specify them
    # within visibleTo field.
    # 50 teams or users in total
    def visible_to=(new_visible_to)
      raise 'visibleTo must be an array!' unless new_visible_to.is_a?(Array)
      raise 'visibleTo must be up to 50 items!' unless new_visible_to.size < 50
      raise 'visibleTo items must include type!' unless new_visible_to.reject { |v| v.include?(:type) }.empty?
      raise 'visibleTo items type must be one of: team or user!' unless new_visible_to.reject { |v| %w[team user].include?(v[:type]) }.empty?
      raise 'visibleTo items must include id, name or username!' unless new_visible_to.reject { |v| v.include?(:id) || v.include?(:name) || v.include?(:username) }.empty?

      @visible_to = new_visible_to unless new_visible_to.empty?
    end

    # Custom actions that will be available for the alert.
    # 10 x 50 characters
    def actions=(new_actions)
      raise 'Actions must be an array!' unless new_actions.is_a?(Array)
      raise 'Actions must be up to 10 items!' unless new_actions.size < 10
      raise 'Action length must not be over 50 characters!' unless new_actions.select { |v| v.length > 50 }.empty?

      @actions = new_actions unless new_actions.empty?
    end

    # Tags of the alert.
    # 20 x 50 characters
    def tags=(new_tags)
      raise 'Tags must be an array!' unless new_tags.is_a?(Array)
      raise 'Tags must be up to 20 items!' unless new_tags.size < 20
      raise 'Tag length must not be over 50 characters!' unless new_tags.select { |v| v.length > 50 }.empty?

      @tags = new_tags unless new_tags.empty?
    end

    # Map of key-value pairs to use as custom properties of the alert.
    # 8000 characters in total
    def details=(new_details)
      @details = new_details[0..8000]
    end

    # Entity field of the alert that is generally used to specify which domain alert is related to.
    # 512 characters
    def entity=(new_entity)
      @entity = new_entity[0..512]
    end

    # Source field of the alert. Default value is IP address of the incoming request.
    # 100 characters
    def source=(new_source)
      @source = new_source[0..100]
    end

    # Priority level of the alert. Possible values are P1, P2, P3, P4 and P5. Default value is P3.
    def priority=(new_priority)
      raise 'Invalid priority!' unless Alert.constants.map { |c| Alert.const_get(c) }.include?(new_priority)

      @priority = new_priority
    end

    # Display name of the request owner.
    # 100 characters
    def user=(new_user)
      @user = new_user[0..100]
    end

    # Additional note that will be added while creating the alert.
    # 25000 characters
    def note=(new_note)
      @note = new_note[0..25_000]
    end

    def to_hash
      props = {
        message: (@message || 'Default alert message'),
        alias: @alias,
        description: @description,
        responders: @responders,
        visibleTo: @visibleTo,
        actions: @actions,
        tags: @tags,
        details: @details,
        entity: @entity,
        source: @source,
        priority: @priority,
        user: @user,
        note: @note
      }

      props.reject { |_, v| v.nil? }
    end
  end
end
