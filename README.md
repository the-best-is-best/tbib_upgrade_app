# Tbib Upgrade App

## Setup

```dart
GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
TBIBCheckForUpdate.init(_navigatorKey);
```

## how to use

```dart
bool newUpdate= TBIBCheckForUpdate.checkForUpdate();

if(newUpdate){
    return;
}
Navigator.push(context, HomeScreen());
```
