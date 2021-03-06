---
title: Reference manual
---

# リファレンスマニュアル

このドキュメントは全ての機能について記載しています。[チュートリアル][tutorial]は、重要な機能について簡単に理解できる事に重点をおいています。このドキュメントは網羅性を重視しています。まだ、[チュートリアル][tutorial]を読んでいないのであれば、このドキュメントを読む前に[チュートリアル][tutorial]を読んでください。

## モジュール {#modules}

LuaWebDriverはひとつだけ公開モジュールがあります。それは、`web-driver`メインモジュールです。 

  * [`web-driver`][web-driver]: メインモジュール。

## 内部モジュール {#internal-modules}

LuaWebDriverは、共通の機能を提供する内部メソッドがあります。これらは、APIとして公開されていませんが、[`web-driver.Element`][element]や[`web-driver.Session`][session]のような公開クラス経由で使えます。

  * [`web-driver.Searchable`][searchable]: 要素検索関連のメソッドを提供します。

## クラス {#classes}

LuaWebDriverは以下のクラスを提供します。

  * [`web-driver.ElementSet`][elementset]: 複数の要素を扱うクラスです。

  * [`web-driver.Element`][element]: 要素を取り扱うためのクラスです。

  * [`web-driver.Firefox`][firefox]: Firefox用のWebDriverクラスです。

  * [`web-driver.Session`][session]: WebDriverのセッションを取り扱うためのクラスです。

  * [`web-driver.ThreadPool`][thread-pool]: このクラスは、スレッドプールを制御するためのクラスです。LuaWebDriverをマルチスレッドで使用する時にこのクラスを使います。

[`web-driver.Firefox`][firefox]のみ直接アクセスできます。その他のクラスへは、[`web-driver.Firefox`][firefox]のメソッド経由でアクセスできます。


[tutorial]:../tutorial/

[web-driver]:web-driver.html

[element]:element.html

[session]:session.html

[searchable]:searchable.html

[thread-pool]:thread-pool.html

[elementset]:elementset.html

[firefox]:firefox.html
