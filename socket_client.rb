require 'socket'    # Sockets is standard lib

# class SocketClient
#   @@hostname = 'localhost'
#   @@port = 8081

#   def send_msg(xmlstr)
#     client = TCPSocket.open(@@hostname, @@port)
#     client.send(xmlstr, 0)  # 0 meas standard packet
#     client.close
#   end
# end

hostname = 'localhost'
port = 8082
tcp_client = TCPSocket.open(hostname, port)
# while line = s.gets # read data from socket by line
#   puts line.chop  # print to terminal
# end
msg = "message..."
# tcp_client.puts(msg)
tcp_client.send(msg, 0)
status = tcp_client.read()
puts status
# tcp_client.close # close the socket