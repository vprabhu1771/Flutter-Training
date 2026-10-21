# iOS App Store Deployment using Fastlane

Here's a complete Fastlane configuration for deploying an iOS app to the App Store, following the same structure as your Android setup.

## iOS `Fastfile` Configuration

Add this to your `Fastfile` (or create a separate one under `ios/fastlane/Fastfile`):

```ruby
default_platform(:ios)

platform :ios do
  desc "Runs all the tests"
  lane :test do
    scan(
      scheme: "YourAppScheme",           # Replace with your Xcode scheme
      device: "iPhone 15",               # Optional: specific simulator
      clean: true
    )
  end

  desc "Submit a new Beta Build to TestFlight"
  lane :beta do
    # Increment build number automatically (uses latest TestFlight build)
    increment_build_number(
      build_number: latest_testflight_build_number + 1
    )

    # Build the app
    build_app(
      scheme: "YourAppScheme",           # Replace with your Xcode scheme
      workspace: "Runner.xcworkspace",   # For Flutter: Runner.xcworkspace
      configuration: "Release",
      export_method: "app-store",        # Required for App Store/TestFlight
      output_directory: "./build/ios/ipa",
      output_name: "YourApp.ipa"
    )

    # Upload to TestFlight
    upload_to_testflight(
      skip_waiting_for_build_processing: true,
      skip_submission: true,
      distribute_external: false         # Set true to invite external testers
    )
  end

  desc "Deploy a new version to the App Store"
  lane :release do
    # Ensure the build number is unique
    increment_build_number(
      build_number: latest_testflight_build_number + 1
    )

    # Build the IPA
    build_app(
      scheme: "YourAppScheme",
      workspace: "Runner.xcworkspace",
      configuration: "Release",
      export_method: "app-store",
      output_directory: "./build/ios/ipa",
      output_name: "YourApp.ipa"
    )

    # Upload to App Store Connect (does NOT auto-submit for review)
    upload_to_app_store(
      skip_metadata: true,               # Don't upload descriptions, title, etc.
      skip_screenshots: true,            # Don't upload screenshots
      skip_binary_upload: false,         # DO upload the IPA
      submit_for_review: false,          # Set true to auto-submit for review
      automatic_release: false,          # Set true to release after approval
      force: true,                       # Skip HTML report verification
      precheck_include_in_app_purchases: false
    )
  end

  # Optional: Submit an already-uploaded build for review
  desc "Submit the latest build for App Store review"
  lane :submit do
    upload_to_app_store(
      submit_for_review: true,
      automatic_release: true,
      force: true,
      skip_metadata: true,
      skip_screenshots: true,
      skip_binary_upload: true           # Use already-uploaded binary
    )
  end

  # Optional: Use Match for code signing (recommended for teams)
  desc "Sync code signing certificates and provisioning profiles"
  lane :certificates do
    match(
      type: "appstore",                  # or "development", "adhoc"
      app_identifier: "com.example.yourapp",
      git_url: "git@github.com:your-org/certificates.git",
      readonly: true                     # true for CI, false to create new certs
    )
  end
end
```

## Setup Steps

### 1. Initialize Fastlane (if not already done)

```bash
cd ios
fastlane init
```

Choose **option 4** ("Manually manage your configuration") or **option 2** ("Automate beta distribution to TestFlight").

### 2. Set up App Store Connect API Key (recommended over Apple ID)

This avoids 2FA issues in CI. Create a key at [App Store Connect → Users and Access → Keys](https://appstoreconnect.apple.com/access/api):

```bash
# Save the .p8 file and note the Key ID and Issuer ID
export APP_STORE_CONNECT_API_KEY_KEY_ID="XXXXXXXXXX"
export APP_STORE_CONNECT_API_KEY_ISSUER_ID="xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
export APP_STORE_CONNECT_API_KEY_KEY_FILEPATH="/path/to/AuthKey_XXXXXXXXXX.p8"
```

Then update your lanes to use it:

```ruby
app_store_connect_api_key(
  key_id: ENV["APP_STORE_CONNECT_API_KEY_KEY_ID"],
  issuer_id: ENV["APP_STORE_CONNECT_API_KEY_ISSUER_ID"],
  key_filepath: ENV["APP_STORE_CONNECT_API_KEY_KEY_FILEPATH"]
)
```

Or use a `Appfile` + `.env` file:

**`fastlane/Appfile`**
```ruby
app_identifier("com.example.yourapp")
apple_id("you@example.com")            # Only needed if not using API key
team_id("ABCDE12345")                  # Your Apple Developer Team ID
itc_team_id("123456789")               # App Store Connect Team ID
```

### 3. Code Signing Options

**Option A — Automatic (simplest for solo devs):**
Xcode → Signing & Capabilities → ✅ Automatically manage signing, then use `build_app` without any `match` config.

**Option B — `match` (recommended for teams / CI):**
```bash
fastlane match init
fastlane match appstore
```

### 4. Run the lanes

```bash
cd ios

# Run tests
fastlane test

# Upload a beta to TestFlight
fastlane beta

# Upload a build to App Store Connect (no auto-submit)
fastlane release

# Submit the latest build for review
fastlane submit
```

## Key Actions Explained

| Action | Purpose |
|---|---|
| `scan` | Runs Xcode tests |
| `increment_build_number` | Bumps CFBundleVersion (`latest_testflight_build_number + 1` is safest) |
| `build_app` | Archives + exports an IPA |
| `upload_to_testflight` | Uploads IPA to TestFlight |
| `upload_to_app_store` | Uploads IPA to App Store Connect; can submit for review |
| `match` | Syncs certificates/profiles from a private Git repo |

## Common Flags for `upload_to_app_store`

```ruby
upload_to_app_store(
  submit_for_review: false,          # Don't auto-submit
  automatic_release: false,          # Don't auto-release after approval
  phased_release: true,              # 7-day phased rollout
  skip_metadata: true,               # Skip description/keywords
  skip_screenshots: true,            # Skip screenshots
  skip_binary_upload: false,         # Upload the IPA
  force: true,                       # Skip HTML verification
  precheck_include_in_app_purchases: false
)
```

## Flutter-Specific Note

For a Flutter project, run `build_app` on the Flutter-generated Xcode workspace:

```ruby
lane :release do
  # First build with Flutter
  sh("cd .. && flutter build ipa --release")
  
  # Then upload the built IPA
  upload_to_app_store(
    ipa: "../build/ios/ipa/YourApp.ipa",
    skip_metadata: true,
    skip_screenshots: true,
    skip_binary_upload: false,
    force: true
  )
end
```

Or simply:

```bash
flutter build ipa --release
cd ios && fastlane release
```

## Typical CI Workflow (GitHub Actions snippet)

```yaml
- name: Deploy to TestFlight
  env:
    APP_STORE_CONNECT_API_KEY_KEY_ID: ${{ secrets.ASC_KEY_ID }}
    APP_STORE_CONNECT_API_KEY_ISSUER_ID: ${{ secrets.ASC_ISSUER_ID }}
    APP_STORE_CONNECT_API_KEY_KEY: ${{ secrets.ASC_KEY_CONTENT }}
    MATCH_PASSWORD: ${{ secrets.MATCH_PASSWORD }}
  run: |
    cd ios
    fastlane beta
```

## Pro Tips

- **Always use `latest_testflight_build_number + 1`** for build numbers — Apple rejects duplicate build numbers.
- **Use an App Store Connect API key** rather than Apple ID + app-specific password; it's more reliable and required for many CI setups.
- **Set `skip_waiting_for_build_processing: true`** on `upload_to_testflight` for faster CI — Apple's processing can take 10–60 min.
- **Use `match` with `readonly: true` in CI** so CI never modifies certificates.
- **Keep `Deliverfile` metadata in Git** if you want `skip_metadata: false` — otherwise set it to `true`.

Want me to tailor this for a specific setup (Flutter, React Native, native SwiftUI, CI provider, etc.)?
