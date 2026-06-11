# ITunesIngestion smoke — drives ITunesConnectError and SalesReportParser constants only
puts ITunesIngestion::ITunesConnectError.superclass
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["1"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["7"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["IA1"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["IA9"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["IAY"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER["F1"]
puts ITunesIngestion::SalesReportParser::PRODUCT_TYPE_IDENTIFIER.size
