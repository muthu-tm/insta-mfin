# insta-mfin

Mobile application for Micro Financial industry.


## Codes used

### Collection Status 
0 - Upcoming
1 - Paid
2 - PaidLate
3 - Current
4 - Pending
5 - Commission

### Colleciton Mode
 0 - Daily
 1 - Weekly
 2 - Monthly

## User Preferences
 0 - Daily
 1 - Weekly
 2 - Monthly

## Customer Status
 0 - New
 1 - Active
 2 - Pending
 3 - Settled
 4 - Blocked

## Build Runner

> flutter pub run build_runner build --delete-conflicting-outputs

## Analytics DebugView
$ From /Users/user_name/Library/Android/sdk/platform-tools

> adb shell setprop debug.firebase.analytics.app com.mfin.insta_mfin