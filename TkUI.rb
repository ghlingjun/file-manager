require 'tk'

class TkUI
  def packing(padx, pady, side=:left, anchor=:n) {
    "padx" => padx, "pady" => pady, "side" => side.to_s, "anchor" => anchor.to_s
  }
  end

  def ui_msg_box(msg)
    root = TkRoot.new { title "Message Box" }
    label_msg = TkLabel.new(root) {
      text msg
      pack :padx=>15, :pady=>10, :side=>'top'
      font "arial 20 bold"
    }
    # TkButton.new do
    #   text "EXIT"
    #   command { exit }
    #   pack('side'=>'left', 'padx'=>10, 'pady'=>10)
    # end
    Tk.mainloop
  end

  def ui_copy_to_usb
    root = TkRoot.new { title "Copy To USB" }

    LabelPack = packing(5, 5, :top, :w)
    EntryPack = packing(5, 2, :top)
    FramePack = packing(2, 2, :top)

    top = TkFrame.new(root)
    tf_reason = TkFrame.new(top)

    # tf_req_retraction = TkFrame.new(top)
    # tf_req_retraction_label = TkFrame.new(tf_req_retraction)
    # tf_req_retraction_radio1 = TkFrame.new(tf_req_retraction)
    # tf_req_retraction_radio2 = TkFrame.new(tf_req_retraction)

    var_reason = TkVariable.new

    tf_reason_label = TkLabel.new(tf_reason) do
      text "Application Reason"
      font "{Arial}" 20 {bold}
      foreground "green"
      background "#606060"
      pack LabelPack
    end

    tf_reason_text = TkEntry.new(tf_reason) do
      textvariable var_reason
      font "Arial 10"
      pack EntryPack
    end

    top.pack FramePack
    tf_reason.pack FramePack

    var_reason.value = ""

    tf_reason_text.focus

    Tk.mainloop
  end
end
