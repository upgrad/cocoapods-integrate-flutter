require 'cocoapods-integrate-flutter/command'
require_relative './cocoapods-integrate-flutter/flutter_pre_install_script'

module CocoapodsIntegrateFlutter
    Pod::HooksManager.register('cocoapods-integrate-flutter', :pre_install) do |context, options|
        IntegrateFlutter.new(options).integrate()
    end
    Pod::HooksManager.register('cocoapods-integrate-flutter', :post_install) do |installer, options|
        IntegrateFlutter.new(options).updateBuildSettingsForTargetsPostInstall(installer)
    end
end
