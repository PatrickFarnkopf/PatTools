#!/usr/bin/ruby

# Created by Patrick Farnkopf

########### Konfiguration ##########
reportResetIntervall    = 30
maxCPUusage             = 25
user                    = 'r1_'
maxReports              = 15
####################################



puts ">>>> Process Controller <<<<"
puts "Starte Process Controller..."
pid = []
circle = 0

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
            end
        end
    end
    sleep(1)
    circle = circle+1
}
