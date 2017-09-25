#!/usr/bin/env ruby
require 'net/http'
require 'uri'

# Check whether a server is responding
# you can set a server to check via http request or ping
#
# server options:
# name: how it will show up on the dashboard
# url: either a website url or an IP address (do not include https:// when usnig ping method)
# method: either 'http' or 'ping'
# if the server you're checking redirects (from http to https for example) the check will
# return false

servers = [{:name=> 'abel', :url=> 'https://abel.crunchrapps.com', :method=> 'http'},
           {:name=> 'achmea', :url=> 'https://achmea.crunchrapps.com', :method=> 'http'},
           {:name=> 'arboned', :url=> 'https://arboned.crunchrapps.com', :method=> 'http'},
           {:name=> 'arcadis', :url=> 'https://arcadis.crunchrapps.com', :method=> 'http'},
           {:name=> 'asr', :url=> 'https://asr.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'beta-naspers', :url=> 'https://beta-naspers.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'beta-randstad', :url=> 'https://beta-randstad.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'capgemini', :url=> 'https://capgemini.crunchrapps.com', :method=> 'http'},
           {:name=> 'cardinal', :url=> 'https://cardinal.crunchrapps.com', :method=> 'http'},
           {:name=> 'careerpaths', :url=> 'https://careerpaths.crunchrapps.com', :method=> 'http'},
           {:name=> 'cn', :url=> 'https://cn.crunchrapps.com', :method=> 'http'},
           {:name=> 'cobra', :url=> 'https://cobra.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'comdata', :url=> 'https://comdata.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'constitution', :url=> 'https://constitution.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'crystal', :url=> 'https://crystal.crunchrapps.com', :method=> 'http'},
           {:name=> 'demo', :url=> 'https://demo.crunchrapps.com', :method=> 'http'},
           {:name=> 'eneco', :url=> 'https://eneco.crunchrapps.com', :method=> 'http'},
           {:name=> 'eriks', :url=> 'https://eriks.crunchrapps.com', :method=> 'http'},
           {:name=> 'eurofibergroup', :url=> 'https://eurofibergroup.crunchrapps.com', :method=> 'http'},
           {:name=> 'expand', :url=> 'https://expand.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'healogics', :url=> 'https://healogics.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'inception', :url=> 'https://inception.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'klm', :url=> 'https://klm.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'lambda', :url=> 'https://lambda.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'liberty', :url=> 'https://liberty.crunchrapps.com', :method=> 'http'},
           {:name=> 'naspers', :url=> 'https://naspers.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'norway', :url=> 'https://norway.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'olympics', :url=> 'https://olympics.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'olympus', :url=> 'https://olympus.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'oz', :url=> 'https://oz.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'platform', :url=> 'https://platform.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'plumb', :url=> 'https://plumb.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'randstad', :url=> 'https://randstad.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'redriver', :url=> 'https://redriver.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'rockwool', :url=> 'https://rockwool.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'rooster', :url=> 'https://rooster.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'schiphol', :url=> 'https://schiphol.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'sphdhv', :url=> 'https://sphdhv.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'thunder', :url=> 'https://thunder.crunchrapps.com', :method=> 'http'},
           {:name=> 'tudelft', :url=> 'https://tudelft.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'unitas', :url=> 'https://unitas.crunchrapps.com', :method=> 'http'},
          #  {:name=> 've', :url=> 'https://ve.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'vodafoneziggo', :url=> 'https://vodafoneziggo.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'workers-preference', :url=> 'https://workers-preference.crunchrapps.com', :method=> 'http'},
          #  {:name=> 'young-professionals', :url=> 'https://young-professionals.crunchrapps.com', :method=> 'http'},
           {:name=> 'zeus', :url=> 'https://zeus.crunchrapps.com', :method=> 'http'},
         ]

SCHEDULER.every '1m', :first_in => 0 do |job|

	statuses = Array.new

	# check status for each server
	servers.each do |server|
		if server[:method] == 'http'
			uri = URI.parse(server[:url])
			http = Net::HTTP.new(uri.host, uri.port)
			if uri.scheme == "https"
				http.use_ssl=true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
			request = Net::HTTP::Get.new(uri.request_uri)
			response = http.request(request)
			if response.code == "200"
			 	result = 1
			 else
			 	result = 0
			 end
		elsif server[:method] == 'ping'
			ping_count = 10
			result = `ping -q -c #{ping_count} #{server[:url]}`
			if ($?.exitstatus == 0)
				result = 1
			else
				result = 0
			end
		end

		if result == 1
			arrow = "fa fa-check"
			color = "green"
		else
			arrow = "fa fa-times"
			color = "red"
		end

		statuses.push({label: server[:name], value: result, arrow: arrow, color: color})
	end

	# print statuses to dashboard
	send_event('server_status', {items: statuses})
end
