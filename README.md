## RSpec編 課題

RSpecの[GitHubのREADME](https://github.com/rspec/rspec-rails)を見て、RUNTEQの課題にそって環境構築やテストコードの作成を行いましょう。

## 注意点

この課題はforkしてご自身のリポジトリを作成して作業してください。  
また、PRのマージをfork元のブランチに対して行わないようにご注意ください。  



## メモ

```
vi /runteq/vendor/bundle/ruby/2.6.0/gems/webdrivers-4.4.2/lib/webdrivers/system.rb

    152       def wsl?
+   153         false
-   154          platform == 'linux' && File.open('/proc/version').read.downcase.include?('microsoft')
    155       end
```
