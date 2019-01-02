require 'cocoapods'
require 'fileutils'

module CocoapodsIntegrateFlutter
    class IntegrateFlutter

    	def initialize(options)
        	@flutter_application_path = options["flutter_application_path"]
        	@framework_dir = File.join(@flutter_application_path, '.ios', 'Flutter')
        	@engine_dir = File.join(@framework_dir, 'engine')
        	@symlinks_dir = File.join(@framework_dir, '.symlinks')
      	end

        def integrate
        	if !File.directory?(@flutter_application_path)
    			Pod::UI.puts "flutter_application_path not found"
    			return
    		end
			
			if !File.exist?(@engine_dir)
			    # Copy the debug engine to have something to link against if the xcode backend script has not run yet.
			    debug_framework_dir = File.join(flutter_root(@flutter_application_path), 'bin', 'cache', 'artifacts', 'engine', 'ios')
			    FileUtils.mkdir_p(@engine_dir)
			    FileUtils.cp_r(File.join(debug_framework_dir, 'Flutter.framework'), @engine_dir)
			    FileUtils.cp(File.join(debug_framework_dir, 'Flutter.podspec'), @engine_dir)
			end

			FileUtils.mkdir_p(@symlinks_dir)
			plugin_pods = parse_KV_file(File.join(@flutter_application_path, '.flutter-plugins'))
			plugin_pods.map { |r|
				puts r[:name]
			    symlink = File.join(@symlinks_dir, r[:name])
			    FileUtils.rm_f(symlink)
			    File.symlink(r[:path], symlink)
                # Doing this in main project Podfile. Figure out a way to do this here.
			    # Pod::Command::Install.run r[:name], :path => File.join(symlink, 'ios')
			}
        end

        def parse_KV_file(file, separator='=')
    		file_abs_path = File.expand_path(file)
    		if !File.exists? file_abs_path
    		    return [];
    		end
    		pods_array = []
    		skip_line_start_symbols = ["#", "/"]
    		File.foreach(file_abs_path) { |line|
    		    next if skip_line_start_symbols.any? { |symbol| line =~ /^\s*#{symbol}/ }
    		    plugin = line.split(pattern=separator)
    		    if plugin.length == 2
    		        podname = plugin[0].strip()
    		        path = plugin[1].strip()
    		        podpath = File.expand_path("#{path}", file_abs_path)
    		        pods_array.push({:name => podname, :path => podpath});
    		     else
    		        puts "Invalid plugin specification: #{line}"
    		    end
    		}
    		return pods_array
		end

		def flutter_root(f)
		    generated_xcode_build_settings = parse_KV_file(File.join(f, File.join('.ios', 'Flutter', 'Generated.xcconfig')))
		    if generated_xcode_build_settings.empty?
		        puts "Generated.xcconfig must exist. Make sure `flutter packages get` is executed in ${f}."
		        exit
		    end
		    generated_xcode_build_settings.map { |p|
		        if p[:name] == 'FLUTTER_ROOT'
		            return p[:path]
		        end
		    }
		end

		def updateBuildSettingsForTargetsPostInstall(installer)
			installer.pods_project.targets.each do |target|
        		target.build_configurations.each do |config|
        		    config.build_settings['ENABLE_BITCODE'] = 'NO'
        		    xcconfig_path = config.base_configuration_reference.real_path
        		    File.open(xcconfig_path, 'a+') do |file|
        		        file.puts "#include \"#{File.realpath(File.join(@framework_dir, 'Generated.xcconfig'))}\""
        		    end
        		end
    		end
		end
    end
end
