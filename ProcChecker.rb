#!/usr/bin/ruby

# Created by Patrick Farnkopf

########### Haupt-Konfiguration ##########
reportResetIntervall    = 30
maxCPUusage             = 50
user                    = 'root'
maxReports              = 10
##########################################

########## SMTP-Konfiguration ############
$mailerEnabled          = true
$tlsEnabled             = false
$hostName               = 'example.com'
$smtpServer             = 'mail.example.com'
$smtpPort               = 25
$smtpUser               = 'daemon@example.com'
$smtpPass               = 'example'
##########################################

########## Mail-Konfiguration ############
$receiver               = 'receiver@example.com'
$from                   = 'ProcChecker Daemon'
$subject                = 'Process stopped'
$serverName             = 'ExampleName'
##########################################


require 'net/smtp'

puts ">>>> Process Controller <<<<"
puts "Starte Process Controller..."
pid = []
circle = 0

def SendMail(info) 
    msg = "From:#{$from}\nSubject:#{$subject}\n\nDer Process Controller Daemon hat einen Prozess auf dem Server #{$serverName} beendet. Folgende Informationen wurden &uuml;bergeben\n\n#{info}"
    smtp = Net::SMTP.new $smtpServer, $smtpPort

    if $tlsEnabled
        smtp.enable_starttls
    end

    smtp.start($hostName, $smtpUser, $smtpPass, :login) do
        smtp.send_message(msg, $smtpUser, $receiver)
    end
end

loop {
    if (circle >= reportResetIntervall)
        circle = 0
        pid = []
    end

    a = `ps -e -o pid,pcpu,user`
    data = a.split("\n")
    for i in 1..data.length-1 do 
        row = data[i].strip
        arR = row.split(" ")
        
        if arR[1].to_f > maxCPUusage and arR[2].include?(user)
            pid[arR[0].to_i] = pid[arR[0].to_i] ? pid[arR[0].to_i]+1 : 0;

            if pid[arR[0].to_i] >= maxReports
                system("kill "+arR[0])
                puts "[DAEMON] Prozess "+arR[0]+" beendet"

                if $mailerEnabled
                    _user = `ps -e -o pid,user | grep #{arR[0]}`.split("\n")[0]
                    _user[arR[0]] = ''
                    com = `ps -e -o pid,command | grep #{arR[0]}`.split("\n")[0]
                    com[arR[0]] = ''
                    SendMail("PID:  #{arR[0]}\nCommand:#{com}\nUser:#{_user}\nTime:  #{Time.now}")
                end
            end
        end
    end
    sleep(1)
    circle = circle+1
}
