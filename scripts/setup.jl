using WebIO
using IJulia

jupyter = ENV["JUPYTER"]
WebIO.install_jupyter_nbextension(`$jupyter`)