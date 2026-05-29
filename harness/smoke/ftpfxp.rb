puts Net::FTPFXP.superclass.name
puts Net::FTPFXPTLS.superclass.name
puts Net::FTPFXPError.superclass.name
puts Net::FTPFXPSrcSiteError.superclass.name
puts Net::FTPFXPDstSiteError.superclass.name
puts Net::FTPFXPTLSError.superclass.name
puts Net::FTPFXPTLS.ancestors.include?(Net::FTPFXP)
puts Net::FTPFXPTLS.instance_method(:feat).owner.name
