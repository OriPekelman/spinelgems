require 'promotion'

# 1. Constants from config modules
puts Folders::Staging           # /var/staging
puts Folders::Crontabs          # /var/cron/tabs
puts Files::Spec                # deploy.xml
puts Files::Profile             # /etc/profile
puts Files::Rc_conf             # /etc/rc.conf.local

# 2. Enforcer default constants
puts Promotion::Enforcer::DEFAULT_FOLDER_OWNER   # root
puts Promotion::Enforcer::DEFAULT_FOLDER_GROUP   # wheel
puts Promotion::Enforcer::DEFAULT_FOLDER_MODE    # 0750
puts Promotion::Enforcer::DEFAULT_FILE_MODE      # 0640

# 3. Mode formatting logic (mirroring ensure_folder formatting)
mode_str = "0750"
mode_int = mode_str.oct
puts sprintf('%04o', mode_int)   # 0750

mode_str2 = "0640"
mode_int2 = mode_str2.oct
puts sprintf('%04o', mode_int2)  # 0640

# 4. Migration version sorting/filtering logic (from Evolver#evolve)
# Simulate what evolve() does with a list of migration files
migrations = [1002, 1001, 1003, 1000].sort
current_version = 1001
target_version  = 0    # 0 means "no cap"
migrations.reject! { |v| v <= current_version }
migrations.reject! { |v| v > target_version } unless target_version == 0
puts migrations.inspect          # [1002, 1003]

# Simulate devolve direction
migrations2 = [1002, 1001, 1003, 1000].sort
current_version2 = 1002
target_version2  = 1000
migrations2.reject! { |v| v > current_version2 }
migrations2.reject! { |v| v <= target_version2 }
migrations2.reverse!
puts migrations2.inspect         # [1002, 1001]

# 5. Groups attribute parsing (whitespace → comma like in Enforcer#ensure_user)
groups_raw = "admin  users  staff"
groups_csv = groups_raw.gsub(/\s+/, ",")
puts groups_csv                  # admin,users,staff

# 6. allfiles mode bit manipulation from ensure_allfiles
base_mode = "0640".oct
perms = sprintf('%9b', base_mode)
perms[2] = "1"
perms[5] = "1"
perms[8] = "1"
folder_mode = perms.to_i(2)
puts sprintf('%04o', folder_mode)  # 0751
