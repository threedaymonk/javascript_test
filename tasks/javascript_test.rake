desc "Run tests for JavaScripts"
task 'test:javascripts' => :environment do
  options = {}
  options[:port] = ENV["JAVASCRIPT_TEST_PORT"].to_i if ENV.has_key? "JAVASCRIPT_TEST_PORT"
  options[:always_close_windows] = true if ENV.has_key? "ALWAYS_CLOSE_WINDOWS"

  JavaScriptTest::Runner.new(options) do |t|
    t.mount("/", RAILS_ROOT)
    t.mount("/test", RAILS_ROOT+'/test')
    t.mount('/test/javascript/assets', File.join(File.dirname(__FILE__), *%w[.. assets]))
    
    Dir.glob('test/javascript/*_test.html').each do |js|
      t.run(File.basename(js,'.html').gsub(/_test/,''))
    end
    
    if ENV["BROWSER"]
      t.browser(ENV["BROWSER"].to_sym)
    else
      t.browser(:safari)
      t.browser(:firefox)
      t.browser(:ie)
      t.browser(:konqueror)
    end
  end
end
