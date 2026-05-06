# SampleWalletApp

## Summary

This is a demo iOS app for an e-wallet. The user can do the following:
* Log in to an account
* See the wallet balance
* Send money
* View transaction history

## Opening the project

To view the source code, open any of the SampleWalletApp `.xcworkspace` or
the `.xcodeproject` files.

## Using the app

To log in, type a username---it can contain only letters and numbers.
Type anything for a password. Sessions and send money transactions are cached
across app launches, but all cached info are lost upon logout.

The dashboard displays the wallet balance and a set of buttons for performing
other supported actions.

## High-level architecture

The app's features are divided across multiple Swift packages. Each package is
a domain and can be owned by one development team in a company.

Packages are distributed across three layers of increasing levels of abstraction.
Dependencies can only go downward---only higher-level packages may import lower-level
packages, but not vice versa. Packages in the same layer may also not import
from each other.

<img src="https://github.com/user-attachments/assets/4e877c0a-a9cf-4a90-8e2b-e9da00e86a5a" />

### Layers in detail

From bottom to top:

* The *core utilities* layer contains Swift packages that offer type definitions
used almost anywhere in higher-layer packages. Only `CoreWebAPI` exists in this
layer for this project---it contains the most foundational types used in building
web services

* The *feature* layer contains packages that divide the app features into
modular domains. Packages in this layer are meant to be consumed as SDKs---they
offer UI components that are fully functional and which can simply be added into
an app's navigation stack.
    * The `Wallet` package contains views that show and mutate data in the
    user's wallet: Dashboard, Send Money, and Transaction History.
    * The `Authentication` package contains views for validating the user's
    identity. For this app, it contains only the Login view.
    
* The *app* layer contains the Xcode target for the iOS app and serves as the
integration point for all of the app's dependencies.

## SwiftUI and UIKit mix-and-match strategy

The app has a UIKit-based view controller hierarchy. SwiftUI is used only for
smaller view components which are added via `UIHostingController`.
This approach provides the highest level of flexibility, allowing for deployment
to as many iOS versions as possible while also making room for new ways of doing things.

The following views are in SwiftUI:

* LoginView
* DashboardView

The following are in UIKit

* SendMoneyView
* TransactionListView - The associated view controller uses compositional
layout and a diffable data source.

## Mock data in transaction history

The app uses the iTunes Search API to fetch a list of rock albums. Albums
have a price and a release date---these are used as the amount sent and the
transaction date, respectively.

Sending money caches the transaction data locally. The locally cached data are
combined with iTunes Search API results to assemble the Transaction History View.

## Minimum iOS target

The minimum iOS target is iOS 15. This is an incredibly low iOS version, but a
reasonable degree of support for apps with large and active user bases.

## Third party libraries

The project contains no third-party libraries.

## Unit tests

Only a few unit tests have been written given the time constraints, but they
make for good examples nonetheless:

* In the `Authentication` package, `LoginViewModelTests` contains unit tests
for validating the username.
* In the `Wallet` package, `TransactionListViewModelTests` verifies that
an HTTP status code of `500` is correctly represented in an error. This
unit test uses a mock `URLProtocol` and does not actually perform a request
over the internet.


## Screen-level code architecture

The code optimizes for readability and ease of doing collaborative work
(i.e. in a team setting) by using as few custom abstractions as possible, and
by using as much of the native platform's idioms. For UIKit components, MVC
dominates. For SwiftUI, very little beyond the `View` itself emerges.

For both UIKit and SwiftUI, screen-level views read their state via a view model.
However, in this codebase, a view model is a lightweight, read-only,
`@MainActor`-isolated data model that contains nothing more than stored properties
that represent view state. Only a view model _controller_ can write to a view model.

A screen-level `UIViewController` or SwiftUI `View` always holds a reference to
the view model controller. When an event warrants that the view state be mutated,
the screen invokes functions in the view model controller. The view model controller
then updates the view model, which has `@Published` properties observed by
a `UIViewController` or a SwiftUI `View`. When a new value is published, views
are re-rendered.

<img src="https://github.com/user-attachments/assets/be4d471a-9d58-4ee0-a3b0-f7af6a126e74" />

This architecture has the following advantages:

* It enforces a downward flow of state.
* Business logic is isolated in the model controller and can therefore be reused.
For example, rewriting a UIKit view into SwiftUI means that you can delete the
`UIViewController` and the `UIView`, but reuse the view model and its controller
in SwiftUI.

The VM-VMC duo also has several advantages over plain MVVM, which typically
combines the two into a single entity:

* It clarifies the boundary between state and business logic.
* The view model can be isolated to the `@MainActor`, which it really should be,
since views must render in the main thread.
* The view model controller is free to define `async` functions to
perform background processing; the view model is not.
* Mutating the view model from a background actor (which could give rise to
race conditions) is a compile-time error.


## Architecture of network requests

Instead of the more popular protocol-oriented repository pattern, this project
represents network requests using a combination of the Command and the Factory
patterns (from the 1995 Design Patterns book by the _Gang of Four_).

```swift
public protocol DataTaskService {
  
  /// Contains the parameters that will be sent to the request.
  associatedtype Parameters
  
  /// Creates a fully-assembled `URLRequest` for a `URLSession` to run as a data task.
  static func request(withParameters parameters: Parameters) throws -> URLRequest
  
  /// The result produced by this service if a web service request succeeds.
  associatedtype Success
  
  /// Creates a success result based on a web service response and its payload.
  static func success(fromData data: Data, response: URLResponse) throws -> Success
  
}
```

_For an example, please see `Wallet.GetFakeTransactions`._

A single web service endpoint implements `CoreWebAPI.DataTaskService`,
which requires that a concrete type implement functions to:

1. Create a fully-assembled `URLRequest` that can be executed by a `URLSession`,
given a set of request parameters.

1. Parse the web service response and create either a success or a failure result from it.

Note that a concrete service itself does not perform a network request. Instead,
it is a mere factory---the generated `URLRequest` must be executed using
`URLSession.data(for:)`. Advantages of this approach include:

* Flexibility to use any of the concurrency models available from Swift:
the classic closure-based syntax, using async/await, or Combine publishers.

* The full logic of a single web service is isolated and not mixed with others.
Makes for easy debugging.

## AI use disclosures

The only places where generative AI was used in this codebase are those involving
regular expressions (I could never remember the syntax):

* In `LoginView`, a regex ensures that the username is composed only of letters and numbers.
* In the `SendMoneyView`, a regex ensures that the entered text is a valid monetary amount.

All other code, including code documentation and this README.md file, are the
author's original work and were written by hand.




