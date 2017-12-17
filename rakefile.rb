require 'xml-dsl'

DOMAIN = 'coel-lang.org'.freeze
ORIGIN = 'coel-lang.github.io'.freeze

file 'favicon.png' do |_t|
  sh 'wget https://raw.githubusercontent.com/coel-lang/icon/master/icon.png'
  sh 'convert -resize 16x16 icon.png favicon.png'
end

task default: 'favicon.png' do
  sh 'terraform init'
  sh "terraform apply -auto-approve -var domain=#{DOMAIN} -var origin=#{ORIGIN}"

  name_servers = `terraform output name_servers`
                 .split(/[,\s]+/)
                 .map { |s| 'Name=' + s }
                 .join ' '

  sh %W[
    aws route53domains update-domain-nameservers
    --domain #{DOMAIN}
    --nameservers #{name_servers}
  ].join ' '
end

task :lint do
  sh 'go get -u github.com/raviqqe/liche'
  sh "liche -v #{Dir.glob('**/*.md').join ' '}"
end