-- WHISPER UBM IOS SDK README --

To add whisper ubm to your Xcode project

1. in your xcode project go to project->general->frameworks & librarie click the plus icon then click add outher->add file, then locate the WHISPERUBM_SwiftSDK.framework file
2. add "import WhisperUBM_SwiftSDK" to the swift file where you want to use the SDK
3. add microphone permissions to your projects info.plist and a way for it be requested from the user inside your app