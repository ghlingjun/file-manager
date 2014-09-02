require 'socket'
include Socket::Constants

server = TCPServer.open(8081)   # The listener port is 2000

loop {                          # The server will run forever
  client = server.accept        # wait for client to connect
  msg = client.recv(1024)
  puts msg
  # client.puts(Time.now.ctime)   # send time to the client
  # client.puts "Closing the connection. Bye!"
  # sleep(3)
  client.send(msg, 0)  # 0 meas standard packet
  client.close                  # close the connection of the client
}
