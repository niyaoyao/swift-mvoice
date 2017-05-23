# NYTools
NYTools is an delightful library for iOS and Mac OS X.It's an tiny library for Swift or Objective-C development.
## Installation
NYTools supports multiple methods for installing the library in a project
### Installation with Carthage
#### Install Carthage
[Carthage] is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.
You can install Carthage with [Homebrew]

```sh
brew update
brew install carthage
```

#### Getting start with NYTools
1. Create **Cartfile** at your project source path
2. Edit **Cartfile** as follow

```sh
github "niyaoyao/NYTools"
```

3. Run ```carthage update``` in Terminal
4. Drag $(PROJECT)/Carthage/Checkouts/NYTools into your project 

### Installation with CocoaPods
(Actually, I prefer use Carthage when project has not to be compatible with less iOS 8.0)
#### Install CocoaPods
1. Create **Podfile**
2. Edit **Podfile** as follow

```ruby
source 'https://github.com/niyaoyao/NYTools.git'
platform :ios, '8.0' 
target 'ProjectName' do
pod 'NYTools', '~>0.0.1'
	
use_frameworks!

end
```

3. Run `pod install`

## License
NYTools is released under the MIT license