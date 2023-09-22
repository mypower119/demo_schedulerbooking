# Demo - SchedulerBooking

## App Flow - BloC
![Preview image](/screenshots/app_flow.png)

## Main features

* Tap on schedule to set your booking or remove booking.
* Drag and drop to update the start and end time of your booking
* Local database with hive

### Project architecture (Clean Architecture Approach)
##### 1. Why:
    * We want to determine what types of database that we use for storage (might want to change it later on)
    * We want to adhere to SOLID principles since we are using OOP for this project.
    * We want to ensure that UI layers do not care what is going on at the data layer at all.
    * We might want to separate each layer into different packages.
##### 2. Presentation - Domain - Data.
##### 3. Presentation layer consist of
    * Widgets
    * BloC - Provider
    * BloC - Provider only manages UI state based on business logic

##### 4. Domain layer (Business logic layer)
    * Repositories (interfaces aka idea how the logic would behave)
    * Entities (or models that UI needs)
    * Usecases (user stories)
    * Typically one function, but can be more if functions are related.
    * Remember, one class has one responsibility only.


##### 5. Data layer (Data access layer)
    * source
        * remotes (API)
        * locals (Database)
    * model
        * request
        * response
    * Repositories (Implementation from Domain layer)
We build this class working separately and not following logics of `Domain layer`. However, `Repositories` will still implement from `Domain layer`, but the `Domain layer` will follow each function, and the `Data layer` will follow the cluster of data defined on the server.
For example: `Domain layer` has defined 2 layers of Login and Register features, but these two features are related to the API User cluster on the server, so in the `Data layer`, there will only be one Repo which is user and that Repo will implement 2 layers Login and Register of the `Domain layer`.

##### 6. More insight of layers
![image](/screenshots/clean_architecture.jpeg)

### DI pattern
`Dependency Injection` is a great design pattern that allows us to eliminate rigid dependencies between elements and it makes the application more flexible, easy to expand scales and maintain.
In the project we use Plugin `get_it` to implement DI and we have also defined classes so you can easily implement `DI` in the `DI layer`.
##### injection
Inject modules
##### module
     * Declare the modules used in the project.
     * All modules must extend "DIModule"
     * The registers must be set in the func provides.
     * When you want to call 1 DI just use the syntax. "getIt.get<My Component>()" or "Injection.getIt<My Component>()"
     * Learn more about "get_it"

### Routes
The project has predefined Named routes RouteDefine + manifest
##### 1. RouteDefine
     * All routes must extend this class.
     * When extending, you will have to override func "initRoute", here you will define your routes.
     * A feature may have multiple routes with different input arguments.
     * Make sure that the ID of each route in your project is unique.
##### 2. manifest - `lib/presentation/routes/routes.dart`
     *  To add a route to the project you just need to declare in the "RouteList". Each route will be provided with a class "Routes" in "lib/app/route.dart", you must call it in the func "getRouteGenerate" of "Routes" to register.
### Network.
     * Project can use retrofit to work with the alternative network for http.
     * Retrofit is pre-installed in the "ApiModule.dart". You can customize it here
     * All interceptors are defined in the lib/common/network/interceptor/* class
     * To work with Certificate, please refer to the "/lib/common/network/http_overrides.dart" class, with the default the project accept badCertificate

### Development environment settings.
     * All flavor environments are installed in the "/lib/common/config/build_config.dart" class.
     * Basically we are defining 4 development environments: development, staging, preprod and release.
     * Run App

##### Gen Assets and source code
You can geb the assets, source code using the command

```
## tools/build-runner.sh
```

##### Clean Flutter source code
You can clean Flutter source code using the command

```
## tools/clean-all.sh
```

##### Build App
You can build the app using the commands

for both Android & iOS:
```
## tools/build-flavor.sh
```

Build by env: Prod, Staging, Dev:
Update FLAVOR value in tools/build-flavor to

```
## development: FLAVOR=${DEV}

## staging: FLAVOR=${STAGE}

## production: FLAVOR=${PROD}
```

for IOS

```
## adhoc || production: build XCode -> TestFlight
```

### resources
      * All resources (images, fonts, videos, ...) must be placed in the assets class

### Json parsing / serialization
This project is implementing [json_serializable](https://pub.dev/packages/json_serializable).
It use build_runner to generate files. If you make a change to these files, you need to re-run the generator using build_runner:
```
tools/build-runner.sh
```

## Indentation.
- Auto indentation handled with git hook using [Lefthook](https://github.com/Arkweid/lefthook).
- For mac users, run `npm run setup` and you should be done. More details below.
- This project use npm for [Lefthook](https://github.com/Arkweid/lefthook) installation, to ease others getting it up running fast - run `npm install`
- After installation, run `npx lefthook install` to finish up installation.
- More info [here](https://github.com/Arkweid/lefthook/blob/master/docs/node.md).

### Localization
Using this library to handle multi-languages. Follow this guide to understand and config languages files

#### Setup Step :

* VSC, AS, IJ users need to install the plugins from the market.
* vs-code: https://marketplace.visualstudio.com/items?itemName=localizely.flutter-intl
* intelliJ / android studio: https://plugins.jetbrains.com/plugin/13666-flutter-intl

* others/CLI:
```
tools/setup-intl.sh
```

### Initialize plugins (IntelliJ reference)
1. Open Flutter intl in `Action`
2. Click on `arb File`

![image](/screenshots/intl_prompt.png)

3. To add / remove Locale, choose `Add Locale` / `Remove Locale`
4. Then it will promp which locale

![image](/screenshots/intl_add_locale.png)

**Current available locale is en, en**


Link library : https://pub.dev/packages/intl_utils
