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

<h3>force upgrade </h3>

```dart
bool newUpdate= TBIBCheckForUpdate.forceCheckUpdate();

if(newUpdate){
    return;
}
Navigator.push(context, HomeScreen());
```

can add your custom upgrader

```dart
TBIBCheckForUpdate.customCheckForUpdate(Upgrader())
```