increase version number automatically

add `script.rb` file:

create new file `script.rb` in android folder: `andoird/script.rb`

this code will edit in your `pubspec.yaml` file to increase your version

```
# pubspec_path = '../pubspec.yaml'
pubspec_path = File.expand_path('../../pubspec.yaml', __FILE__)

# Read the file into an array of lines
lines = File.readlines(pubspec_path)

# Find the line containing the version and update it
lines.map! do |line|
  if line.strip.start_with?('version:')
    if line =~ /(\d+)\.(\d+)\.(\d+)\+(\d+)/
      major, minor, patch, build = $1.to_i, $2.to_i, $3.to_i, $4.to_i
      patch += 1
      build += 1
      line = "version: #{major}.#{minor}.#{patch}+#{build}\n"
    end
  end
  line
end

# Write the updated lines back to the file
File.open(pubspec_path, 'w') { |file| file.puts(lines) }
```

open: `android/fastlane/Fastfile` file, in this file you will add your sitting for increase your version number automatically

```
lane :icrease_build_number do
  # script.rb is a ruby script that increments the build number in pubspec.yaml
  system("ruby ../script.rb")
end
```

now increase your build number in pubspec.yaml
now in your terminal run the following commands:

```
cd ./android/
fastlane icrease_build_number 
cd ..
```

you can use both of release or internal and icrease_build_number fastlane action to fully automate your deployment steps using this code:

```
cd ./android/
fastlane icrease_build_number
cd ..
flutter clean
flutter pub get
flutter build appbundle
cd ./android/
fastlane release # or use internal 
cd ..
```
