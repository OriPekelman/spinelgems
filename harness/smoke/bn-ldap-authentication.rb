# Smoke: bn-ldap-authentication - exercises LDAP_ATTRIBUTE_MAPPING constant
puts LdapAuthenticator::LDAP_ATTRIBUTE_MAPPING.class
puts LdapAuthenticator::LDAP_ATTRIBUTE_MAPPING.keys.sort.inspect
puts LdapAuthenticator::LDAP_ATTRIBUTE_MAPPING['uid'].inspect
puts LdapAuthenticator::LDAP_ATTRIBUTE_MAPPING['email'].inspect
puts LdapAuthenticator::LDAP_ATTRIBUTE_MAPPING.size
