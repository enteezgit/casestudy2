# See https://docs.getchef.com/config_rb_knife.html for more information on knife configuration options

current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "admin"
client_key               "#{current_dir}/admin.pem"
chef_server_url          "https://10.51.238.183/organizations/persistent"
cookbook_path            ["#{current_dir}/../cookbooks"]
validation_client_name   "persistent-validator"
validation_key           "#{current_dir}/persistent-validator.pem"
syntax_check_cache_path  "#/home/niloday/chef-repo/.chef/syntaxcache"
cookbook_path            ["/home/niloday/chef-repo/cookbooks"]

no_proxy                 '127.0.0.1,10.51.238.183,gadevopsnt2,*.persistent.com,*.persistent.co.in'
http_proxy               'http://niloday_tamhankar:Dev0ps2016@ptproxy.persistent.co.in:8080'
https_proxy              'https://niloday_tamhankar:Dev0ps2016@ptproxy.persistent.co.in:8080'
ssl_verify_mode          :verify_none



