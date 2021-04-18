# docker-l4n-bionic-ja

- 日本語版Lin4Neuro (Ubuntu 18.04) のDockerイメージ

## 使い方

- ターミナルで以下をタイプしてください

```
docker run -it -p 6080:80 --shm-size=1024m kytk/docker-l4n-bionic-ja:latest

```

- こうするとコンテナが起動します。

- ホームディレクトリで "jpsettings.sh" を実行します。ホームディレクトリのディレクトリを英語化すると同時に、日本語の設定をします。これは1回だけで大丈夫です。

```
cd
./jpsettings.sh
```


- 次に、ホームディレクトリで "vncsettings.sh" を実行します。解像度を引数で指定することができます。特に指定しなければ、1280x800 となります。

- 例として、もし、解像度を 1920x1080 としたかったら以下をタイプします。

```
cd
vncsetings.sh 1920x1080
```

- パスワードを設定します。自分の好みでいいのですが、ここでは 'lin4neuro' とします。

```
You will require a password to access your desktops.

Password:lin4neuro
Verify:lin4neuro
Would you like to enter a view-only password (y/n)? n
```

- その次にスクリプトは brain に対するパスワードを聞いてきます。これは 'lin4neuro' です。

```
[sudo] password for brain: lin4neuro
```

- これで準備完了です。次に、自分のホストでブラウザを起動し、以下をタイプします。

```
localhost:6080/vnc.html
```

ここでパスワードに lin4neuro を入力すれば、起動します。

