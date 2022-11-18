module StepsHelper




def getStepSound(mystep)
soundID = "0"
puts mystep.data
if valid_json?(mystep.data)
if Sound.find_by(id: JSON.parse(mystep.data)[0][1]) != nil
soundID = Sound.find_by(id: JSON.parse(mystep.data)[0][1]).id
end
end

soundID
end


def getStepMenu(mystep)
menuID = "0"
puts mystep.data
if valid_json?(mystep.data)
if Route.find_by(id: JSON.parse(mystep.data)[0][1]) != nil
menuID = Route.find_by(id: JSON.parse(mystep.data)[0][1]).id
end
end

menuID
end

def getStepExten(mystep)
dialoptions = {}
puts mystep.data
if valid_json?(mystep.data)
if Exten.find_by(id: JSON.parse(mystep.data)[0][1]) != nil
extenID = Exten.find_by(id: JSON.parse(mystep.data)[0][1]).id
end
dialtimeout = JSON.parse(mystep.data)[1][1]
dialoptions = JSON.parse(mystep.data)[2][1]

dialoptions= {:exten_id => extenID,:dialoptions => dialoptions, :dialtimeout => dialtimeout}
end
dialoptions
end



def getStepRead(mystep)
readoptions = {}
puts "DATA:"
puts mystep.data
if valid_json?(mystep.data)
if Sound.find_by(id: JSON.parse(mystep.data)[0][1]) != nil
soundID = Sound.find_by(id: JSON.parse(mystep.data)[0][1]).id
end
maxlen = JSON.parse(mystep.data)[1][1]
readtimeout = JSON.parse(mystep.data)[2][1]


read0 = JSON.parse(mystep.data)[3][1]
read1 = JSON.parse(mystep.data)[4][1]
read2 = JSON.parse(mystep.data)[5][1]
read3 = JSON.parse(mystep.data)[6][1]
read4 = JSON.parse(mystep.data)[7][1]
read5 = JSON.parse(mystep.data)[8][1]
read6 = JSON.parse(mystep.data)[9][1]
read7 = JSON.parse(mystep.data)[10][1]
read8 = JSON.parse(mystep.data)[11][1]
read9 = JSON.parse(mystep.data)[12][1]

puts read0
puts read1
puts read2
puts read3
readoptions= {:sound_id => soundID,:maxlen => maxlen, :timeout => readtimeout,"read0" => read0,"read1" => read1,"read2" => read2,"read3" => read3,"read4" => read4,"read5" => read5,"read6" => read6,"read7" => read7,"read8" => read8,"read9" => read9}
end
readoptions
end









def getStepQueue(mystep)
dialoptions = {}
puts mystep.data
if valid_json?(mystep.data)
if Hotline.find_by(id: JSON.parse(mystep.data)[0][1]) != nil
queueID = Hotline.find_by(id: JSON.parse(mystep.data)[0][1]).id
end
puts queueID
dialoptions = JSON.parse(mystep.data)[1][1]

dialoptions= {:queue_id => queueID,:dialoptions => dialoptions}
end
dialoptions
end


def getStepVoicemail(mystep)
dialoptions = {}
puts mystep.data
if valid_json?(mystep.data)
if Exten.find_by(id: JSON.parse(mystep.data)["exten_id"]) != nil
vmID = Exten.find_by(id: JSON.parse(mystep.data)["exten_id"]).id
end
puts vmID
dialoptions = JSON.parse(mystep.data)["options"]
puts dialoptions
dialoptions= {:exten_id => vmID,:dialoptions => dialoptions}
end
dialoptions
end

def getStepRingGroup(mystep)
dialoptions = {}
puts mystep.data
if valid_json?(mystep.data)
dialoptions = JSON.parse(mystep.data)["options"]
timeout = JSON.parse(mystep.data)["timeout"]
extens = JSON.parse(mystep.data)["extens"]
moh_id = JSON.parse(mystep.data)["moh_id"]
puts dialoptions
dialoptions= {:extens => extens,:dialoptions => dialoptions,:dialtimeout => timeout,:moh_id => moh_id}
end
dialoptions
end





def getStepDialExternal(mystep)
dialoptions = {}
puts mystep.data
if valid_json?(mystep.data)

number = JSON.parse(mystep.data)[0][1]
if Sip.find_by(id: JSON.parse(mystep.data)[1][1]) != nil
sipID = Sip.find_by(id: JSON.parse(mystep.data)[1][1]).id
end
dialtimeout = JSON.parse(mystep.data)[2][1]
dialoptions = JSON.parse(mystep.data)[3][1]

dialoptions= {:number => number,:sip_id => sipID,:dialoptions => dialoptions, :dialtimeout => dialtimeout}
end
dialoptions
end



def valid_json?(json)
  JSON.parse(json)
  true
rescue JSON::ParserError => e
  false
end

end
