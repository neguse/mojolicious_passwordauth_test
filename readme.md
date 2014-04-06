# これはなにか
[Mojolicious](http://mojolicio.us/)用にパスワード認証を行うだけのページを実装してみました。
パスワードは、[Crypt::PBKDF2](http://search.cpan.org/~arodland/Crypt-PBKDF2/)モジュールを使ってハッシュ化して保存してあるので、なんとなく安全な気がします。

# 使い方
[Carton](https://github.com/miyagawa/carton)が使える環境で、以下のコマンドを実行します。

    # モジュールのインストール
    carton install
    # テーブルの作成
    carton exec perl script/create_table
    # アプリの起動
    carton exec morbo script/auth_lite

# TODO
* ドキュメンテーション
* DBファイルのパスを設定ファイルとかに逃す
* テスト
* Mojolicious::LiteからMojoliciousに載せ替える(モデル自体は分離されているので楽なはず)

