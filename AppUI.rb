require "tk"

class AppUI
  def copy_to_usb_ui
    msg="Hello World!"
    root=TkRoot.new{title msg}
    label_msg=TkLabel.new(root){
        text  msg
        pack :padx=>2,:pady=>2,:side=>'top'
        font "arial 20 bold"
    }
    Tk.mainloop
  end
end
