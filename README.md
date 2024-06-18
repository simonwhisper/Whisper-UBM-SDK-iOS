-- WHISPER UBM IOS SDK README --

To add Whisper ubm to your Xcode project

1. In your xcode project go to project->general->frameworks & library click the plus icon then click add other->add file, then locate the WHISPERUBM_SwiftSDK.framework file.
2. Add "import WhisperUBM_SwiftSDK" to the swift file where you want to use the SDK.
3. Add microphone permissions (privacy - microphone usage description) to your project's info.plist and add the necessary code to request the permission from the user inside your app.