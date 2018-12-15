# cocoapods-integrate-flutter

Uses the podhelper.rb from the flutter repository and adds to the pre_install hook of cocoapods. Integrates the flutter project without polluting the main Podfile.

## Installation

    $ gem install cocoapods-integrate-flutter

## Usage

	In your host project Podfile, write the below line
    ```
    plugin 'cocoapods-integrate-flutter' , {
  		:flutter_application_path => '../src'
	}
	```
