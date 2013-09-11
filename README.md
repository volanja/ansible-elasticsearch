ansible-elasticsearch
=====================

ansibleを使って、ログデータの収集と全文検索可能なマシンを構築します。  
以下のソフトウェアをインストールします。  
elasticsearch…ログデータのリアルタイム全文検索・分析エンジン  cool. bonsai cool  
kibana3…ログの可視化ソフトウェア  
fluentd…ログデータの収集ソフトウェア  

ansible...サーバ構成管理ソフトウェア  

対象環境
-----
CentOS 6.4 64bit   (virtualbox + vagrantで構築)

実行環境
-----
	$ ansible --version  
	ansible 1.2.2

	$ ruby -v  
	ruby 1.9.3p194 (2012-04-20 revision 35410) [x86_64-darwin11.4.2]

	$ gem list |grep serverspec  
	serverspec (0.7.12)

インストールするもの
------
+ elasticsearch  
 - plugin bigdesk  
 - plugin head  
+ kibana3
+ fluentd
+ nginx

使い方
-----
1. hostsファイルの設定変更  
clone後、hostsファイル内の対象サーバのIPアドレスを変更してください。

2. SSH公開鍵認証の準備  
対象サーバにSSH公開鍵認証方式でログイン出来るように準備してください。

3. ホスト名の変更  
サーバのホスト名を初期値es-server以外にする場合は、注意点1を参照し、  
あらかじめ変更してください。

4. ansible playbook 実行  
次のコマンドで実行します。  

	$ ansible-playbook setup.yml -i hosts  

たまにyumで失敗することがありますが再度実行するとうまくいくことがあります。

5. テストの準備  
Serverspecで行います。  
spec/default をspec/xxx.xxx.xxx.xxxと変更してください。

6. テストの実行  
次のコマンドで実行します。  

	$ rake spec

7. 再起動  
ここで一度再起動してください。

8. kibana3へのアクセス  
次のURLでアクセスできます。  

	http://IPアドレス/  

画面上部に次のエラーがでますが、elasticsearch上にデータがないとでるようです。  

	Error Could not find http://192.168.0.109:9200/_all/_mapping. If you are using a proxy, ensure it is configured correctly

9. elasticsearchのプラグインbigdeskへのアクセス  
次のURLでアクセスできます。  

	http://IPアドレス:9200/_plugin/bigdesk  

10. elasticsearchのプラグインheadへのアクセス  
次のURLでアクセスできます。  
	
	http://IPアドレス:9200/_plugin/head  

注意点
-----
1. サーバホスト名のハードコード  
いくつかの設定ファイルにサーバのホスト名をハードコードしています。  
(ホスト名未設定の場合にkibanaにうまくアクセスが出来ずハマりました。)  
実際に動かす際には、環境に合わせて変えてください。  
初期値ではes-serverです。  
	$ find ./  |xargs grep -n es-server  
	./roles/es/templates/elasticsearch.yml:202:    network.bind_host: es-server  
	./roles/nginx/templates/nginx.conf:4:          server_name           es-server;  
	./roles/td-agent/templates/td-agent.conf:14:   host es-server  
	./roles/kibana/vars/main.yml:3:                 servername: es-server  

2. fluntdの収集先  
初期設定では、fluentdのログ収集先は/var/log/nginx/access.logにしています。  
つまり、構築後にkibanaに何度かアクセスすると、elascticsearchにログが保存されます。  
動作確認用なので、早めに設定を変えてください。  

リンク
-----
+ [elasticsearch](http://www.elasticsearch.org/)
 - plugin [bigdesk](https://github.com/lukas-vlcek/bigdesk/)
 - plugin [head](http://mobz.github.io/elasticsearch-head/)
+ [kibana3](http://three.kibana.org/)
+ [fluentd](http://fluentd.org/)
+ [nginx](http://nginx.org/ja/)
