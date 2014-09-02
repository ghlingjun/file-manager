require 'socket'    # Sockets is standard lib
require 'timeout'
require 'tk'

class SocketClient
  @@hostname = 'localhost'
  @@port = 8081

  def send_msg(xmlstr)
    client = TCPSocket.open(@@hostname, @@port)
    client.send(xmlstr, 0)  # 0 meas standard packet
    timeout(5) do
      status = client.read()
      # puts status
    end
    # client.close
  end
end

class TkUI
  @root

  def msg_box(msg)
    @root = nil
    @root = TkRoot.new { title "Message Box" }
    label_msg = TkLabel.new(@root) {
        text msg
        pack :padx=>15,:pady=>10,:side=>'top'
        font "arial 20 bold"
    }
    # TkButton.new do
    #   text "EXIT"
    #   command { exit }
    #   pack('side'=>'left', 'padx'=>10, 'pady'=>10)
    # end
    Tk.mainloop
  end
end

class SocketServer
  def tcp_server
    msg = ""
    # @t = Thread.new do
    #   ui = TkUI.new
    #   ui.msg_box(@msg)
    # end
    server = TCPServer.open(8082)   # The listener port is 2000
    loop {                          # The server will run forever
      # client = server.accept
      # session = server.accept
      # msg = session.recv(1024)
      # puts msg
      # session.close                # close the connection of the client
      Thread.start(server.accept) do |session|
        msg = session.recv(1024)
        puts msg
        session.close                # close the connection of the client
        ui = TkUI.new
        ui.msg_box(msg)
      end
    }
  end
end

class ReadFile
  def read_file(file_name)
    xmlstr = ""
    file = File.open(file_name, "r")
    file.each {
      |line| xmlstr << line
    }
    file.close
    return xmlstr
  end
end

class FileManager
  def new_file(xmlstr)
    client = SocketClient.new
    client.send_msg(xmlstr)
  end

  def update_file(xmlstr)
    new_file(xmlstr)
  end

  def copy_to_usb(xmlstr)
  end
end

socket_server_thread = Thread.new do
  server = SocketServer.new
  server.tcp_server
end

file_read = ReadFile.new
file_manager = FileManager.new
file_manager.new_file(file_read.read_file("new_file.xml"))
file_manager.update_file(file_read.read_file("update_file.xml"))

socket_server_thread.join
