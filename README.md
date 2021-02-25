# liber-opsgenie
Liber opsgenie notification gem

## Usage

```
require 'liber_opsgenie'

# OPS_GENIE env should contain the api key fot the project

unless !Rails.env.production? || ENV['OPS_GENIE'].nil?
  a = OpsGenie::Alert.new()
  a.message = "Some error message"
  a.alias = Digest::SHA256.hexdigest(fail_messages.join("\n\n"))
  a.entity = 'Project: Context'
  a.priority = OpsGenie::Alert::P1 # Priority level available on GEM
  a.tags = ['project-tag', 'context-tag']
  a.note = fail_messages.join("\n")
  s = OpsGenie::Sender.new(ENV['OPS_GENIE'])
  s.send(a)
end

```
