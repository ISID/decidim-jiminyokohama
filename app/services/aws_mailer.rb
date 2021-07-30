require 'net/smtp'
require "kconv"

class AwsMailer
    def initialize
        @sender = ENV['SMTP_ADDRESS']# SMTPのメールアドレス
        @senderName = ENV['SENDER_NAME']# 組織名
        @server = 'email-smtp.us-east-1.amazonaws.com'
        @recipient = ENV['SYSTEM_MAIL']# 送信先
        @port = 587 
    end


    def send(subject, recipient, mail_subject, mail)
      reg = Regexp.compile("[^\s]+@[^\s]+")
      if reg =~ recipient[0]#メールアドレスが妥当な場合
          message = [
              #Remove the next line if you are not using a configuration set
              "Content-Type: text/html; charset=UTF-8",
              "Content-Transfer-Encoding: quoted-printable",
              "From: #{@senderName} <#{@sender}>",
              "To: #{@recipient}",
              "Subject: Mail sent to #{recipient}",
              "<h1></h1>",
              "",
              "invitation_token: #{mail.scan(/invitation_token=3D\S+/)}" #現状は7bitのまま送信されてしまう
              ].join("\n")
      
      else
          message = [
              #Remove the next line if you are not using a configuration set
              "Content-Type: text/html; charset=UTF-8",
              "Content-Transfer-Encoding: 7bit",
              "From: #{@senderName} <#{@sender}>",
              "To: #{@recipient}",
              "Subject: mail not sent to #{recipient}",
              "",
              "<h1>Invalid email address</h1>",
               "invitation_token: #{mail.scan(/invitation_token=3D\S+/)}" #現状は7bitのまま送信されてしまう
              ].join("\n")
      end
      begin
          smtp.send_message(message, @sender, @recipient)
      # Print an error message if something goes wrong.
      rescue => e
          puts e
      end
  end

  #private

  def smtp
      @smtp = Net::SMTP.new(@server, @port)
      # Tell the smtp object to connect using TLS.
      @smtp.enable_starttls
      # Open an SMTP session and log in to the server using SMTP authentication.
      @smtp.start(@server, smtp_username, smtp_password, :login)
      @smtp
  end

  def smtp_password
      @stmp_password = ENV['SMTP_PASSWORD']
  end

  def smtp_username
      @stmp_username = ENV['SMTP_USERNAME']
  end
end