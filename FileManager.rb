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

class CommonUtils
  def packing(padx, pady, side=:left, anchor=:n)
    { "padx" => padx, "pady" => pady, "side" => side.to_s, "anchor" => anchor.to_s }
  end
end

class TkUI
  def ui_msg_box(msg)
    root = TkRoot.new { title "Message Box" }
    label_msg = TkLabel.new(root) {
      text msg
      pack :padx=>15, :pady=>10, :side=>'top'
      font "arial 20 bold"
    }
    TkButton.new do
      text "EXIT"
      command { root.destroy }
      pack('side'=>'left', 'padx'=>10, 'pady'=>10)
    end
    Tk.mainloop
  end

  def ui_copy_to_usb(xmlstr)
    root = TkRoot.new { title "Copy To USB" }

    def packing(padx, pady, side=:left, anchor=:n)
      { "padx" => padx, "pady" => pady, "side" => side.to_s, "anchor" => anchor.to_s }
    end
    # utils = CommonUtils.new

    # LabelPack = packing(5, 5, :top, :w)
    # EntryPack = packing(5, 2, :top)
    # FramePack = packing(2, 2, :top)

    # LabelPack = { "padx" => 5, "pady" => 5, "side" => :top, "anchor" => :w }
    # EntryPack = { "padx" => 5, "pady" => 2, "side" => :top, "anchor" => :n }
    # FramePack = { "padx" => 2, "pady" => 2, "side" => :top, "anchor" => :n }

    top = TkFrame.new(root)
    tf_reason = TkFrame.new(top)
    tf_req_retraction = TkFrame.new(top)
    tf_buttons = TkFrame.new(top)

    # var_reason = TkVariable.new

    tf_reason_label = TkLabel.new(tf_reason) do
      text "Application Reason"
      font "Arial 20 bold"
      foreground "black"
      # background "#606060"
      pack("padx"=>5, "pady"=>5, "side"=>:top, "anchor"=>:w)
    end

    tf_reason_text = TkText.new(tf_reason) do
      width 77
      height 3
      borderwidth 1
      font TkFont.new('times 12 bold')
      pack("padx"=>5, "pady"=>2, "side"=>:top, "anchor"=>:n)
    end

    tf_req_retraction_label = TkLabel.new(tf_req_retraction) do
      text "Automatic Restraction"
      font "Arial 20 bold"
      foreground "black"
      # background "#606060"
      pack("padx"=>5, "pady"=>5, "side"=>:top, "anchor"=>:w)
    end

    # PackOpts = { "side" => "top", "anchor" => "w" }
    major = TkVariable.new
    tf_req_retraction_radio1 = TkRadioButton.new(tf_req_retraction) do
      variable major
      text "Yes"
      value 1
      command { puts "Major = #{major.value}" }
      pack "side" => "left"
    end
    tf_req_retraction_radio2 = TkRadioButton.new(tf_req_retraction) do
      variable major
      text "No"
      value 2
      command { puts "Major = #{major.value}" }
      pack "side" => "left"
    end

    tf_buttons_approval = TkButton.new(tf_buttons) do
      text "Approval"
      command proc {
        file_manager.copy_to_usb(file_read.read_file(xmlstr))
        root.destroy
      }
      pack "padx" => 15, "pady" => 5, "side" => "left", "anchor" => "center"
    end

    tf_buttons_ = TkButton.new(tf_buttons) do
      text "Peer Support"
      command proc {}
      pack "padx" => 15, "pady" => 5, "side" => "left", "anchor" => "center"
    end

    top.pack("padx"=>2, "pady"=>2, "side"=>:top, "anchor" => :n)
    tf_reason.pack("padx"=>2, "pady"=>2, "side"=>:top, "anchor" => :n)
    tf_req_retraction.pack "side" => "top", "anchor" => "w"
    tf_buttons.pack "side" => "top"

    tf_reason_text.insert 'end', ""

    tf_reason_text.focus

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
        msgbox = TkUI.new
        msgbox.ui_msg_box(msg)
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
    ui = TkUI.new
    ui.ui_copy_to_usb(xmlstr)
  end
end

socket_server_thread = Thread.new do
  server = SocketServer.new
  server.tcp_server
end

root = TkRoot.new
root.title = "Main Window"

Tk.mainloop

file_read = ReadFile.new
file_manager = FileManager.new
# file_manager.new_file(file_read.read_file("new_file.xml"))
# file_manager.update_file(file_read.read_file("update_file.xml"))
file_manager.copy_to_usb("copy_to_usb.xml")
