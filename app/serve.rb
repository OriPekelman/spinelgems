# spinelgems.org served by a Spinel-compiled Tep binary.
# Compile: tep build app/serve.rb -o serve_bin ; run: ./serve_bin -p $PORT
# NOT passed to spinel directly — the tep translator rewrites the do/end
# route blocks into Tep::Handler subclasses first.
require 'sinatra' # ignored by the translator; documentation-only

set :public_dir, './public'

get '/' do
  "<!doctype html><meta charset=utf-8><title>SpinelGems</title>" +
  "<h1>SpinelGems on Tep</h1>" +
  "<p>Served by a Spinel-compiled Tep binary on Upsun. (spike)</p>"
end

get '/healthz' do
  "ok"
end
