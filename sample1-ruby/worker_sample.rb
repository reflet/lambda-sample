require 'sinatra/base'
require 'open-uri'
require 'aws-sdk'

class WorkerSample < Sinatra::Base
    set :logging, true
    set :public_folder, 'public'

    get '/' do
        redirect '/index.html'
    end

    post '/' do
        msg_id = request.env["HTTP_X_AWS_SQSD_MSGID"]
        data = request.body.read
        File.open("/tmp/sample-app.log", 'a') do |file|
            file.puts "#{data}"
        end
        html = open(data)
        File.open("/tmp/sample-app.log", 'a') do |file|
            file.puts "#{html}"
        end
        Aws.config[:region] = 'ap-northeast-1'
        s3 = Aws::S3::Client.new
        s3.put_object(
            bucket: "******"
            body: html
            key: 'test'
        )
    end
end
