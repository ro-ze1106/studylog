# アプリケーションの概要

作成した問題を記録して出題でき、その問題を共有できる問題投稿SNSサービス。
お試しログインがあるので気軽に、ログインして下さい。
### リンク
https://app.studylog-tomo.com

# アプリケーションの機能

* 作成した問題を投稿
* 画像を投稿（Active Storageを使用）
* 問題の出題（作成した問題を出題し、解答を入力する事で答えの合否を判断してくる）
* フォロー
* コメント
* お気に入り
* 通知（お気に入り登録、コメントがあった場合）
* 検索（Ransackを使用）
* ログイン
* ログイン状態の保持
* モデルに対するバリデーション

# 使用した技術
* フロントエンド
    * HTML
    * SCSS
    * JavaScript
    * Bootstrap 5.1.3

* バックエンド
    * Ruby 3.0.2
    * Ruby on Rails 6.1.4
    * Rspec (テスト)
    * Rubocop (コード解説ツール)

インフラ
* インフラ・本番環境
    * Docker/Docker-compose
    * AWS（VPC、EC2、RDS、S3、Route53、ALB、ACM、IAM）
    * CircleCI (CI/CD)

# 技術ポイント
* AWS EC2/RDSを用いたRails本番環境構築
* AWS ACMでSSL証明書を発行し、SSL化
* 独自ドメイン取得、使用
* Dockerを用いたRails開発環境構築
* Ajaxを用いた非同期処理（フォロー/未フォロー、お気に入り登録/未登録などの切り替え表示）
* Bootstrapによるレスポンシブ対応
* CircleCIを使用し、CI/CDパイプラインを構築している点
* Githubのissue、pull requestsを活用したチーム開発を意識している点

# インフラ構成図

![Untitled Diagram](https://user-images.githubusercontent.com/85288297/165872708-c3f2292a-ea61-446a-845c-85aeb2181a7c.png)

# ER図

![ER図(studylog)](https://user-images.githubusercontent.com/85288297/165872215-2d966ea1-f26b-437d-859d-9afb77fef585.png)