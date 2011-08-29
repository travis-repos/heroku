file pkg("heroku-toolbelt-#{version}.deb") => distribution_files do |t|
  tempdir do |dir|
    mkchdir("usr/local/heroku") do
      assemble_distribution
      assemble_gems
      assemble resource("deb/heroku"), "bin/heroku", 0755
    end

    assemble resource("deb/control"), "control"
    assemble resource("deb/postinst"), "postinst"

    sh "tar czvf data.tar.gz usr/local/heroku"
    sh "tar czvf control.tar.gz control postinst"

    File.open("debian-binary", "w") do |f|
      f.puts "2.0"
    end

    sh "ar -r #{t.name} debian-binary control.tar.gz data.tar.gz"
  end
end

task "deb:build" => pkg("heroku-toolbelt-#{version}.deb")

task "deb:clean" do
  clean pkg("heroku-toolbelt-#{version}.deb")
end

task "deb:release" => "deb:build" do |t|
end
