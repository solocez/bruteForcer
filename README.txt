App is test task to implement Brute Forcer app.

ARCHITECTURE ASPECTS:
App is implemented based on MVVM+Coordinator pattern.
Logic is based on Rx - reactive.
Core/initial component is ApplicationCoordinator instance - it's an entry point of the app.
A Coordinator has set of attached screens - in the case of the task, only one Screen is attached and managed by ApplicationCoordinator instance - it's FirstScreen.

CORE CLASSES where main logic is concentrated:
- ApplicationCoordinator - entry point
- FirstScreenController/FirstScreenViewModel - UI of a main screen + high level logic of the app.
- StringMixer - utility class to mix all possible variants of string(s).
- BasicAuthenticationCommand - logic around network request to perform login operation.
- LoginAttempt - wrapper around Operation class - to manage numerious login attempts.

Rest of clasess are secondary.


